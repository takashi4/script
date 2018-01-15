#!/usr/bin/env perl

#最初の100個のフィボナッチ数のリストを計算する関数を記述せよ。
#定義では、フィボナッチ数列の最初の2つの数字は0と1で、次の数は前の2つの合計となる。
#例えば最初の10個のフィボナッチ数列は、0, 1, 1, 2, 3, 5, 8, 13, 21, 34となる。

use strict;
use warnings;

use Memoize;
memoize('_fib');

use Data::Printer;

my @result = fib_100();
p@result;

sub fib_100 {
    return map {_fib($_)} (0..99);
}

sub _fib {
    my $_n = shift;
    
    return $_n==0 ? 0
          : $_n==1 ? 1
          : _fib($_n-1)+_fib($_n-2)
          ;
}