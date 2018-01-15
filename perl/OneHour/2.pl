#!/usr/bin/env perl

#交互に要素を取ることで、2つのリストを結合する関数を記述せよ。
#例えば [a, b, c]と[1, 2, 3]という2つのリストを与えると、関数は [a, 1, b, 2, c, 3]を返す。

use strict;
use warnings;

use Data::Printer {multiline =>0};

my @a=qw(a b c);
my @b=qw(1 2 3);

p@a;
p@b;

my @c=_combine(\@a, \@b);

p@c;

sub _combine {
    my ($_a, $_b) = @_;
    my @_a = @$_a;
    my @_b = @$_b;
    
    my @_c = ();
    for (my $i=0; $i<@_a; ++$i) {
        push(@_c, $_a[$i], $_b[$i]);
    }
    
    return @_c;
}
