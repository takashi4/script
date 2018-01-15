#!/usr/bin/env perl

#forループ、whileループ、および再帰を使用して、リスト内の数字の合計を計算する3つの関数を記述せよ。

use strict;
use warnings;

use Data::Printer;

my @a = (1..10);
p@a;

# For ループ版
my $result_for = 0;
for (my $i=0; $i<@a; ++$i) {
    $result_for += $a[$i];
}
print $result_for, "\n";

# While ループ版
my $result_while = 0;
my $j=0;
while ($j < @a) {
    $result_while += $a[$j++];
}
print $result_while,"\n";

# 再帰版
my $result_rec = _loop(0, 0);
print $result_rec,"\n";
sub _loop {
    my ($k, $acc) = @_;
    return $k < @a ? _loop($k+1, $acc+$a[$k]) : $acc;
}

