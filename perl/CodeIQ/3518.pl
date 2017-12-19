#!/usr/bin/env perl

use strict;
use warnings;
use bigint;

chomp(my $arg = <>);

my ($m,$n) = split('/', $arg);

my ($m_k, $n_k) = _get_KIYAKU($m,$n);

my $rate = 10**(53-length($m_k));

#有限小数で表現
if ($m_k*$rate % $n_k) {
  print "$m_k/$n_k\n";
}
else {
  if ($m_k % $n_k) {
    my $x = sprintf("%.20f", $m_k / $n_k);
    $x =~ s/0*$//;
    print $x,"\n";
  }
  else {
    print $m_k/$n_k, "\n";
  }
}

sub _get_KIYAKU {
    my ($i, $j) = @_;
    
    my $gcd = _get_gcd($i,$j);

    return ($i/$gcd, $j/$gcd);
}

sub _get_gcd {
    my ($i,$j) = @_;
    my $k = $i % $j;
    return $k ? _get_gcd($j, $k) : $j;
}