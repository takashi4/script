#!/usr/bin/env perl

use strict;
use warnings;

my ($m, $n, $_dummy) = split(/\s+/, <>);

# i+ j+ k = m
# i+2j+3k = n
# -> j+2k = n-m
my $result = 0;
my $k = 0;
my $j = $n-$m -2*$k;
for (; $j>= 0; $k++, $j = $n-$m -2*$k) {
  my $i = $k + 2*$m-$n;
  $result++ if $i>=0;
#print <<DEBUG;
#義務チョコ:$i 義理チョコ:$j 本命チョコ:$k
#DEBUG
  
}

print $result;

  