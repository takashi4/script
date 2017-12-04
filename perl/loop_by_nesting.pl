#!/usr/bin/env perl

use strict;
use warnings;

use Data::Dumper qw(Dumper);

chomp(my $arg=<>);

my ($n, $m) = split(/\s+/, $arg);
my @maps = ();

loop(0, 0, {});

print Dumper \@maps;
sub loop {
    my ($i,$j, $h) = @_;
    if ($j == $m) {
        push(@maps, [
            map { $h->{$_} } (0..($n-1))
        ]);
        return;
    }

    for (my $k=1+$i; $k<$n-$m+$j; ++$k) {
        $h->{$k} = 1;
        loop($k, $j+1, $h);
        delete $h->{$k};
        
        $h = {} if ($j==0);
    }
}

