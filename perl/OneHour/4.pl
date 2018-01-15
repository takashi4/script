#!/usr/bin/env perl

#正の整数のリストを与えられたとき、数を並び替えて可能な最大数を返す関数を記述せよ。
#例えば、[50, 2, 1, 9]が与えられた時、95021が答えとなる

use strict;
use warnings;

use List::Util qw(reduce max);
use Data::Printer {multiline=>0};

my @inp = qw(
    50 2 1 9 94 
);
p@inp;
my @out = _max_chr(@inp);
p@out;

sub _max_chr {
    my @_inp = @_;
    
    return max(map {reduce {"$a$b"} @$_} @{_perm(@_inp)});
}

sub _perm {
    my @_inp = @_;
    return [\@_inp] if scalar @_inp == 1;

    my @ret = ();
    foreach my $i (@_inp) {
        my @i = grep {$_ ne $i} @_inp;
        
        push(@ret, map {[$i,@$_]} @{_perm(@i)});
    }

    return \@ret;
}