#!/usr/bin/env perl

use strict;
use warnings;
use Memoize;
memoize('pick');

chomp(my $N = <>);
my %hash = map {$_ => undef} (1..$N);
my @ARR = 1..$N;

my $total = 0;
print pick(1, @ARR), "\n";
sub pick {
    my ($k, @arr) = @_;
    if ($k == $N) {
        return $arr[0] == $k ? 0 : 1;
    }
    my $count = 0;
    
    my $n = scalar @arr;
    for (my $i=0; $i<$n; ++$i) {
        my ($_k) = splice( @arr, $i, 1 );
        if ($_k == $k) {
            splice(@arr, $i, 0, $_k);
            next;
        }
        $count += pick($k+1, @arr);
        splice(@arr, $i, 0, $_k);
    }
    return $count;
}

