#!/usr/bin/env perl

use strict;
use warnings;

chomp($_ = <>);
my ($m, $n) = split(/\s+/);
my %maze;
for (my $i=0; $i<$m; $i++) {
  chomp($_ = <>);
  my @ns = split('');
  for (my $j=0; $j<$n; $j++) {
    $maze{$i}{$j} = $ns[$j] eq '.' ? 0 : 'X';
  }
}


