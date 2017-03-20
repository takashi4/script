#!/usr/bin/env perl

use strict;
use warnings;

chomp($_=<>);
my ($n, $m) = split(/\s+/);
my $ret = 0;

for (my $i=0; $i<=$n; $i++)
{
  my $ones = 0;
  map  { $ones++ }
  grep { $_ == 1 }
  split("", sprintf("%b", $i));
  if ($ones == $m)
  {
    $ret++;
  }  
}

print $ret;

