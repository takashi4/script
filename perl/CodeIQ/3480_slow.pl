#!/usr/bin/env perl

# 速度問題で、999999 1111　のみタイムオーバー（１秒以内）
# 素数表作るだけで、数秒かかっている。
# 高速な素数表作成か、素数表を作らないかのどちらか

use strict;
use warnings FATAL => 'all';

use List::Util qw(first max);

chomp(my $arg = <>);
my ($m, $n) = split(/\s/, $arg);

my @init = grep {$_%2 && $_%3 && $_%5 && $_%7}(2..$m);
my @primes = qw(2 3 5 7);

prime2(\@init, 11);
push(@primes, @init);

my $max_prime = $primes[$#primes];
my $max_distance =  $max_prime - 2;

my $max_R = int($max_distance/($n-1));


for (my $R = $max_R; $R > 0; --$R) {
    my $lp = 2;
    my $ok;
    for (my $i=0; $i<$n-1; ++$i) {
        $lp = first {$_ >= $lp+$R} @primes;

        if (! defined $lp || $lp > $max_prime) {
            undef $ok;
            last;
        }
        $ok = 1;
#print<<DEBUG;
#====== lp=$lp R=$R max_R=$max_R ==========
#DEBUG
    }
    if ($ok) {
        print $R, "\n";
        exit;
    }
}

sub prime {
    my ($arr, $divisor) = @_;
    
    @$arr = grep { $_ == $divisor || $_ % $divisor } @$arr;
    my $new_divisor = first {$_ > $divisor} @$arr;
    my $max = max @$arr;
    return $divisor > sqrt($max) ? $arr : prime($arr, $new_divisor);
}

sub prime2 {
    my ($arr, $divisor) = @_;
    
    my $max_sq = sqrt($arr->[$#$arr]);
    while (1) {
        return [@primes, @$arr] if $divisor > $max_sq;

        @$arr = grep {$_%$divisor} @$arr;
        
        push( @primes, $divisor );
        $divisor = $arr->[0];
    }
}