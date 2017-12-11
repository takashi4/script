use strict;
use warnings;

use List::Util qw(first);
use YAML;

chomp(my $n = <>);

_make_maps(1);
_make_maps(2);
_make_maps(3);

die;

my $i = 1;
for (; $i<=$n; ++$i) {
    my @maps = _make_maps($i);
    last if (_is_ok(@maps));
}

print $i, "\n";

# $m個の目盛を持ったスケールマップの作成
sub _make_maps {
    my $m = shift;
    
    my @ret;
    _loop_by_nest(\@ret, $m, []);
    
print "========== make_maps ==========\n";
print Dump \@ret;
    return @ret;
=pod
$m=3の場合の例
    for (my $i=0; $i<$n-$m+1; ++$i) {
        for (my $j=$i+1; $j<$n-$m+2; ++$j) {
            for (my $k=$j+1; $k<$n-$m+3; ++$k) {
                push(@ret, [$i,$j,$k]);
            }
        }
    }
=cut
}

sub _loop_by_nest {
    my ($arr, $m, $acc) = @_;
#print Dump $arr;
    
    if ($m == scalar @$acc) {
        push(@$arr, $acc);
    }
    else {
        my $i = scalar @$arr;
        my $j = $i == 0 ? -1 : $arr->[-1];
        for (my $k=$j+1; $k<$n-$m+$i+1; ++$k) {
            push(@$acc, $k);
            _loop_by_nest($arr, $m, $acc);
        }
    }
}

# 渡されたマップ群が1..$nまでを計測できるか
sub _is_ok {
    foreach my $map (@_) {
        push(@$map, map {$_+$n} @$map[0..($#$map-1)]);
        for (my $i=1; $i<=$n; ++$i) {
            next unless _can_measure($map, $i);
        }
print Dump $map;        
        return 1;
    }
    return 0;
}

sub _can_measure {
    my ($map, $i) = @_;
    
    my %hash = map {$_=>1} @$map;
    for (my $j=0; $j<@$map; ++$j) {
       return 1 if defined $hash{$map->[$j] + $i};
    }
    
    return 0;
}