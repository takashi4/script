#!/usr/bin/env perl

use strict;
use warnings;

# $M個の場所に、$N 回ネストループする
# ネストループする際に、外側のループ変数より大きくする
# for (my $i = 0; $i < $M; ++$i) {
#   for (my $j = $i; $j < $M; ++$j) {
#     for (my $k = $j; $k < $M; ++$k) {
# ........

my ($M, $N) = (20, 10);

_loop(0, 1, {});

sub _loop {
    # $i:外側ループ変数（スタート） $n:ネスト深さ  $h:渡す値
    my ($i, $n, $h) = @_;
    
    for (my $_i = $i; $_i < $M; ++$_i) {
        if ($n == $N) {
            print join("----", map {$h->{$_}} sort {$a <=> $b} keys %$h );
        }
        else {
            $h->{$n} = $_i;
            _loop($_i, $n+1, $h);
        }
    }
    
}
