#!/usr/bin/env perl

use strict;
use warnings;

while (<>) {
  my $line = <>;
  chomp($line);
  
  my @input = split(/\s+/, $line);
  my $flg = 0;
  LABEL: for (my $i=0; $i < @input - 1; $i++) {
    for (my $j=$i+1; $j < @input; $j++) {
      if ($input[$i]+$input[$j] == 256) {
        print "yes\n";
        $flg = 1;
        last LABEL;
      }
    }
  }
  print "no\n" if (! $flg);
}
