#!/usr/bin/env perl

#0から9の整数を、縦横それぞれN個並べた四角形があります。
#左上から右下に、右あるいは下へと移動しながら、数を足していきます。
#複数ある経路のうち、最小合計値となる経路をたどった場合の、合計値を答えてください。
#ただし、Nは、2≦N≦1000 の範囲の整数とします。
#
#例
#567
#133
#502
#route: 51302, sum: 11
# ⇒ 11
#
#56713350
#23542393
#19595213
#74241524
#52644987
#02912978
#72796409
#27353017
# ⇒ 55 （不正解）
# ⇒ 49 (OK)
#
#567133502354239319 (200x200)
#.........
# ⇒　timeout (849?)

use strict;
use warnings;

#use Data::Printer {multiline => 0};

my (@map,@min_map) = ();
while (<>) {
    chomp;
    my @row = split('');
    push(@map, \@row);
    push(@min_map, [(undef)x@row]);
}

my $N = scalar @map;

_promote(0,0,0);
print $min_map[$N-1][$N-1], "\n";
#p@min_map;

# 前進
sub _promote {
    my ($x,$y, $old_val) = @_;
#print "==== _promote($x,$y,$old_val) =====\n";    
    my $val = $old_val + $map[$x][$y] ;
    return if (defined $min_map[$x][$y] && $val >= $min_map[$x][$y]);

    $min_map[$x][$y] = $val;
    
    if ($x < $N-1) {
        _promote($x+1, $y, $val);
        
    }
    if ($y < $N-1) {
        _promote($x, $y+1, $val);
    }
    
    return 1;
}
