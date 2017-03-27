#!/usr/bin/env perl

use strict;
use warnings;

while (<>) {
  chomp;
  my $N = $_;
  unless ($N % 2) {
    print "0\n";
    next;
  }
  
  my $k_max = _get_max_k($N);
  print( ($k_max+1)/2 );
  print "\n";
}

sub _get_max_k {
  my $n = shift;
  my $ret = int(1_999_999/$n);
  
  return $ret % 2 ? $ret : $ret - 1;
}