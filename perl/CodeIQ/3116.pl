#!/usr/bin/env perl

use strict;
use warnings;

while (<>) {
  chomp;
  my @input = split(//);
  ONE: while (@input) {
    last ONE if (@input == 1);
    TWO: for (my $i=0; $i<@input; $i++) {
      last ONE if ($i == $#input);
      if (abs( $input[$i] - $input[$i+1] ) == 1) {
        splice(@input, $i, 2);
        last TWO;
      }
    }
  }
  print join('', @input);
  print "\n";
}

    