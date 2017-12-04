#!/usr/bin/env perl

use strict;
use warnings;

use List::Util qw(shuffle);

chomp(my $args = <>);
my ($n,$k) = split(/\s+/, $args);

print(
    ($n%2 && $k%2) || !($n%2 || $k%2) ? _calc($n,$k)
                                        : 0
, "\n");

sub _calc {
    my ($n, $k) = @_;
    my $m = ($n - $k)/2;
    
    return int C($n, $m)*C($n-$m, $k)*2**$k/C(2*$n, $n)*10**6; 
}

sub C {
    my ($c, $r) = @_;
    return 1 if $c == $r || $r == 0;
    
    my $m = $c-$r >= $r ? $r : $c-$r;
    my $ret = 1;
    
    for (my $i=$c; $i>$c-$m; --$i) {
        $ret *= $i;
    }
    for (my $i=$m; $i>1; --$i) {
        $ret /= $i;
    }
    
    return $ret;
}