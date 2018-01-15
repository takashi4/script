#!/usr/bin/env perl

use strict;
use warnings;

chomp(my $num = <>);

unless ($num%2) { print "invalid\n"; exit; }

if ($num == 1) { print "i\n"; exit; }

print "."x($num/2-1),"iii","."x($num/2-1),"\n";
for (my $i=1; $i<$num-1; ++$i) {
  print "."x($num/2),"i","."x($num/2),"\n";
}
print "."x($num/2-1),"iii","."x($num/2-1),"\n";
