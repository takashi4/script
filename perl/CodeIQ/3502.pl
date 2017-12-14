use strict;
use warnings;

use List::Util qw(first);
use Time::HiRes qw(time);

#use Data::Printer {multiline=>0};

#問題例
#6	3
#10	4
#14	5
#22	6
#28 6 ←初回、これだけタイムオーバー

chomp(my $n = <>);

my $i = 1;
for (; $i<=$n; ++$i) {
    #my $start = time();
    
    #my $maps = _make_maps($i);
    
    #print_debug($start, "_make_maps($i)");
    #$start = time();
    
    #last if (_is_ok(@$maps));
    last if _make_maps_is_ok($i);
    
    #print_debug($start, "_is_ok:".scalar @$maps);
}

print $i, "\n";

sub print_debug {
    my ($s, $comment) = @_;
    my $elapsed = time() - $s;
    
    print <<DEBUG;
===== $comment $elapsed =====
DEBUG
}

# $m個の目盛を持ったスケールマップの作成
sub _make_maps {
    my $m = shift;
    my $j = 0;
    my %h = ();
    my $ret = _make_comb($m-1, [1..($n-1)]);

    for (@$ret) {
        next if (_eq_array($_, _axial_symm($_)));
        if (! defined $h{join(",", @$_)}) {$h{join(",", @{_axial_symm($_)})} = 1}
    }

    my @_ret =
        map  {unshift(@$_, 0); $_     }
        grep {! defined $h{join(",", @$_)}}
       @$ret;

    return \@_ret;
}

sub _make_maps_is_ok {
    my $m = shift;
    my %h = ();
    my $ret = _make_comb($m-1, [1..($n-1)]);

    MAP:
    for (@$ret) {
        my $key = join(",", @$_);
        my $skey = join(",", @{_axial_symm($_)});
        
        next if (defined $h{$key});
        $h{$skey} = 1;
        
        my @map = (0,@$_);
        push(@map, map {$_+$n} @map[0..($#map-1)]);

        for (my $j=1; $j<=$n; ++$j) {
            next MAP unless (_can_measure(\@map, $j));
        }
        return 1;
    }
    return 0;
}

# $_arr の中から $_n 個を選ぶ組合せを生成
my %cache;
sub _make_comb {
    my ($_n, $_arr) = @_;
    #return _make_comb2($_n, $_arr, [], []);
    
    #my $key=join(',',@$_arr);
    #if (defined $cache{$_n} && defined ($cache{$_n}{$key})) {
    #    return $cache{$_n}{$key};
    #}
    my @arr = @$_arr;
    
    my $ret;
    if ($_n == 0) {$ret = [[]]}
    elsif (@arr == 0) { $ret = [] }
    else {
        my $x = shift @arr;
        $ret = [
            (map { [$x, @$_] } @{_make_comb($_n-1, \@arr)}),
            @{_make_comb($_n, \@arr)},
        ];
    }
    
    #$cache{$_n}{$key} = $ret;
    return $ret;
}

sub _make_comb2 {
    my ($_n, $_xs, $_ys, $_zs) = @_;
    my @xs = @$_xs;

    my $key=join(',',@$_xs);
    if (defined $cache{$_n} && defined ($cache{$_n}{$key})) {
        return $cache{$_n}{$key};
    }
    
    my $ret;
    if ($_n==0) {$ret=[[reverse @$_ys], @$_zs];}
    elsif (scalar @$_xs == 0) { $ret=$_zs; }
    else {
        my $x = shift @xs;
        $ret=_make_comb2( $_n-1, \@xs, [$x, @$_ys], _make_comb2($_n, \@xs, $_ys, $_zs) );
    }
    
    $cache{$_n}{$key} = $ret;
    return $ret;
}

# 渡されたマップ群が1..$nまでを計測できるか
sub _is_ok {
    MAP:
    foreach my $map (@_) {
        #next if _is_already_checked($map);
#p $map;
        push(@$map, map {$_+$n} @$map[0..($#$map-1)]);
        for (my $i=1; $i<=$n; ++$i) {
            next MAP unless _can_measure($map, $i);
        }
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

# $map の線対称性を利用して探索を半減
my %already_checked_maps;
sub _is_already_checked {
    my $map = shift;
    my $map_num = scalar @$map;

    if (defined $already_checked_maps{$map_num}) {
        
        foreach my $_map (@{$already_checked_maps{$map_num}}) {
            if (_eq_array($_, $map)) {
                _push_noexist( $already_checked_maps{$map_num}, _axial_symm( $map ));
                return 1;
            }
            elsif (_eq_array($_, _axial_symm( $map ))) {
                _push_noexist( $already_checked_maps{$map_num}, $map );
                return 1;
            }
        }

    }
    else {
        push( @{$already_checked_maps{$map_num}}, $map );
        push( @{$already_checked_maps{$map_num}}, _axial_symm( $map ));
    }
    
    return 0;
    
}

sub _push_noexist {
    my ($arr, $_arr) = @_;
    
    if (first {_eq_array($_, $_arr)} @$arr) {return};
    
    push(@$arr, $_arr);
}

sub _axial_symm {
    my $map = shift;

    return [
        reverse map { $n-$_ } @$map
    ];
}

sub _eq_array {
    my ($arr1, $arr2) = @_;
    return 0 unless defined $arr1 && defined $arr2;

    return join(",", @$arr1) eq join(",", @$arr2);
}