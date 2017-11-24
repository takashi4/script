#!/usr/bin/env perl

use strict;
use warnings;

while (<>) {
    chomp(my $n = $_);

    my $count = 0;
    for (my $i=1; $i<=$n; ++$i) {
        for (my $j=1; $j<=$i; ++$j) {
            for (my $k=1; $k<=$j; ++$k) {
            
                ++$count if ($i<$j+$k);
#                if ($i<$j+$k) {
#                    print <<DEBUG;
#(i,j,k)=($i,$j,$k)
#DEBUG
#                }
            }
        }
    }
    
    print $count, "\n";
}
