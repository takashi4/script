#!/usr/bin/env perl

use strict;
use warnings;

my $N = 1000;
my $MAX1 = 1*$N;
my $MAX5 = $MAX1 + 5*$N;
my $MAX10 = $MAX5 + 10*$N;
my $MAX50 = $MAX10 + 50*$N;
my $MAX100 = $MAX50 + 100*$N;
my $MAX500 = $MAX100 + 500*$N;

chomp(my $input=<>);
if ($input > $MAX500) {
  print "0";
  exit 1;
}

my $ret = 0;
for (my $i500 = 0; $i500<=$N && (my $res500 = $input - 500*$i500)>=0; $i500++) {
  if ($res500 > $MAX100) {
    next;
  }
  for (my $i100=0; $i100<=$N && (my $res100 = $res500 - 100*$i100)>=0 ; $i100++) {
    if ($res100 > $MAX50) {
      next;
    }
    for (my $i50=0; $i50<=$N && (my $res50 = $res100 - 50*$i50)>=0; $i50++) {
      if ($res50 > $MAX10) {
        next;
      }
      for (my $i10=0; $i10<=$N && (my $res10 = $res50 - 10*$i10)>=0; $i10++) {
        if ($res10 > $MAX5) {
          next;
        }
        for (my $i5=0; $i5<=$N && (my $res5 = $res10 - 5*$i5)>=0; $i5++) {
          if ($res5 > $MAX1) {
            next;
          }
          $ret++;
        }
      }
    }
  }
}

print $ret;

