#!/usr/bin/env perl

# 速度問題で、999999 1111　のみタイムオーバー（１秒以内）
# 素数表作るだけで、数秒かかっている。
# 高速な素数表作成か、素数表を作らないかのどちらか

use strict;
use warnings FATAL => 'all';

use List::Util qw(first max);

chomp(my $arg = <>);
my ($m, $n) = split(/\s/, $arg);

my $max_prime = getMaxPrime($m);
my $max_distance =  $max_prime - 2;

my $max_R = int($max_distance/($n-1));

LOOP:
for (my $R = $max_R; $R > 0; --$R) {
    my $lp = 2;
    my $ok;
    for (my $i=0; $i<$n-1; ++$i) {
        $lp = getMinPrime($lp+$R);
print <<DEBUG;
====== lp=$lp  R=$R  max_prime=$max_prime ==========
DEBUG
        next LOOP if ($lp > $max_prime);
    }

    print $R, "\n";
    exit;
}

sub getMinPrime {
    my $nn = shift;
    
    my $min = $nn%2 ? $nn : $nn+1;
    for (my $i=$min; ; $i += 2) {
        return $i if isPrime($i);
    }
    
    die "Can't get Prime Number";

}

sub getMaxPrime {
    my $nn = shift;
    
    my $max = $nn%2 ? $nn : $nn-1;
    for (my $i=$max; $i>2; $i -= 2) {
        return $i if isPrime($i);
    }
    die "Can't get Prime Number";
}

sub isPrime {
    my $x = shift;
    return undef unless ($x%2 && $x%3 && $x%5 && $x%7);
    
    my $xx = sqrt($x);
    for (my $i=11; $i <= sqrt($x); $i+=2) {
        return undef unless ($x%$i);
    }
    
    return 1;
}
