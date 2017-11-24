#!/usr/bin/env perl

use strict;
use warnings;

while (<>) {
    chomp(my $n = $_);

    my $count = 0;
    for (my $i=$n; $i>0; --$i) {
        my $jj = int( $i/2 );
        $count += -$i*($i - $jj) + $i*($i+1) - $jj*($jj+1);
    }
    
    print $count, "\n";
}
