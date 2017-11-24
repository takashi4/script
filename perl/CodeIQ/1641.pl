#!/usr/bin/env perl

use strict;
use warnings;
use Memoize;
memoize('pick');

chomp(my $N = <>);

# f(n) = (n-1) * { f(n-1) + f(n-2) }
my $total = 0;
print pick($N), "\n";
sub pick {
    my ($k) = @_;
    return $k <= 1 ? 0
          : $k == 2 ? 1
          : ($k-1)*(pick($k-1) + pick($k-2))
          ;
}

