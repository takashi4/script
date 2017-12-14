#!/usr/bin/env perl

use strict;
use warnings;

use YAML;
use Data::Printer {multiline => 1, indent => 2};
use Data::Clone qw(clone);

chomp(my $args = <>);

my ($n, $i) = split(/\s+/, $args);

# 1～$n の数字列の中から $i 個を選択する組合せを生成する
# Haskell からの移植
=pod
comb' :: Int -> [a] -> [[a]]
comb' 0 _  = [[]]
comb' _ [] = []
comb' n (x:xs) = map (x:) (comb' (n-1) xs) ++ comb' n xs
=cut

my $ret = _make_comb($i, [1..$n]);

p $ret;
print scalar @$ret, "\n";

sub _make_comb {
    my ($_n, $_arr) = @_;
    
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
