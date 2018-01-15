#!/usr/bin/env perl

#1,2,…,9の数をこの順序で、"+"、"-"、またはななにもせず結果が100となるあらゆる組合せを出力するプログラムを記述せよ。
#例えば、1 + 2 + 34 – 5 + 67 – 8 + 9 = 100となる

use strict;
use warnings FATAL=> 'all';

use List::Util qw(reduce);

use Data::Printer {multifile=>0};

my @inp = (1..9);
my @OPS = ( " + ", " - ", "" );

#print eval(reduce {"$a$b"} @{${_make_comb(@inp)}[1397]});
#exit;

foreach my $comb (@{_make_comb(@inp)}) {
    my $s = reduce {"$a$b"} @$comb;
    print join('', @$comb), "\n" if (eval($s) eq 100);
}

sub _make_comb {
    my @t = @_;
    return [\@t] if (scalar @t == 1);

    my $first = shift @t;
    my @ret = ();
    foreach my $op (@OPS) {
        push(@ret, map { [$first,$op, @$_] } @{_make_comb(@t)} );
    }
    
    return \@ret;
}
