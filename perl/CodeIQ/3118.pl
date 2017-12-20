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

use List::Util qw(min);

#use Data::Printer {multiline => 0};

my (@map,@min_map) = ();
while (<>) {
    chomp;
    my @row = split('');
    push(@map, \@row);
    push(@min_map, [(undef)x@row]);
}

my $N = scalar @map;

_make_min_map();
print $min_map[$N-1][$N-1], "\n";
#p@min_map;

#...X...
#..YZ... Zに進むのはＸからかＹから
#.......
#1行目から順に下に向かって min_map を作成

sub _make_min_map {
    # １行目は特別
    $min_map[0][0] = $map[0][0];
    for (my $i=1; $i<$N; ++$i) {
        $min_map[0][$i] = $map[0][$i] + $min_map[0][$i-1];
    }
    # ２行目以降は上から降りてくる（Ｘ）のと左からくる（Ｙ）場合に、小さいほうを採用
    for (my $i=1; $i<$N; ++$i) {
        $min_map[$i][0] = $map[$i][0] + $min_map[$i-1][0];
        for (my $j=1; $j<$N; ++$j) {
            my $x = $min_map[$i-1][$j  ];
            my $y = $min_map[$i  ][$j-1];
            $min_map[$i][$j] = min($x,$y) + $map[$i][$j];
        }
    }
}
