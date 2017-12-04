#!/usr/bin/env perl

use strict;
use warnings;

<>;

my %result;
while (<>) {
    chomp;
    my @line = split(",");
    
    for (my $i=0; $i<@line; ++$i) {
        $result{$i}{$line[$i]} = 1;
    }
}

print join(',',
    map {
        scalar keys %{$result{$_}}
    }
    sort {$a <=> $b}
    keys %result
), "\n";
