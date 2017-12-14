#!/usr/bin/env perl

use strict;
use warnings;

use Data::Clone qw(clone);

use Data::Printer {multiline=>0};

chomp(my $args = <>);
my ($n,$_i) = split(/\s+/, $args);

=pod
期待する結果
$i: _make_maps の引数
    $i=1; [[0]]
    $i=2; [[0,1],[0,2],[0,3],[0,4]]
    $i=3; [[0,1,2],[0,1,3],[0,1,4],[0,2,3],[0,2,4],[0,3,4]]
    $i=4; [[0,1,2,3],[0,1,2,4],[0,1,3,4],[0,2,3,4]]
    $i=5; [[0,1,2,3,4]]
]
=cut

#for (my $i=1; $i<=$n; ++$i) {
for (my $i=1; $i<=$_i; ++$i) {
    print "============= _make_maps($i) ==============\n";
    #p _make_maps($i);
    _make_maps($i);
}

sub _make_maps {
    my $m = shift;
    
    my $ret = _make_comb($m-1, [1..($n-1)]);
    map {unshift(@$_, 0)} @$ret;
    return $ret;
}

# $_arr の中から $_n 個を選ぶ組合せを生成
sub _make_comb {
    my ($_n, $_arr) = @_;
    return _make_comb2($_n, $_arr, [], []);

    my $arr = clone $_arr;
    
    if ($_n == 0) {return [[]]}
    elsif (@$arr == 0) { return [] }
    else {
        my $x = shift @$arr;
        return([
            (map { [$x, @$_] } @{_make_comb($_n-1, $arr)}),
            @{_make_comb($_n, $arr)},
        ]);
    }
}

#    comb 0 _ ys zs = reverse ys : zs
#    comb _ [] _ zs = zs
#    comb n (x:xs) ys zs = comb (n-1) xs (x:ys) (comb n xs ys zs)
sub _make_comb2 {
    my ($_n, $_xs, $_ys, $_zs) = @_;
    my @xs = @$_xs;
    
    if ($_n==0) {return( [[reverse @$_ys], @$_zs] );}
    elsif (scalar @$_xs == 0) { return $_zs; }
    else {
        my $x = shift @xs;
        return _make_comb2( $_n-1, \@xs, [$x, @$_ys], _make_comb2($_n, \@xs, $_ys, $_zs) );
    }
}