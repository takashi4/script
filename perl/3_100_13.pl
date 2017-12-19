#!/usr/bin/env perl

use strict;
use warnings;
use bigint;

my $n = shift(@ARGV);
my $p = shift(@ARGV);
my $q = shift(@ARGV) || 20;

my %h;
for (my $i=0; $i<$q; ++$i) {
    my $m = $n**$i%$p;
    if (defined $h{$m}) {
        print<<DEBUG;
======== Found same result ===========
DEBUG
    }
    else { $h{$m} = 1; }
    
    print<<DEBUG;
$n ^ $i mod $p = $m
DEBUG
    
}