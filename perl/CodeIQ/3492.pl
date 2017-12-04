#!/usr/bin/env perl

use strict;
use warnings;

use Memoize;
memoize(qw(C comb divisors));

chomp(my $n = <>);

print "invalid\n" if $n<3;

my $total_comb = 0;
for (my $i=1; $i<=$n/3; ++$i) {
    for (my $j=$i; $j<=$n-$i-$j; ++$j) {
        my $k = $n-$i-$j;

        if ($i==$j && $i==$k) {
            my $p = comb($i);
            $total_comb += H($p, 3);
            #print_debug($i, $j, $k, "i,j,k same === ".H($p, 3));
        }
        elsif ($i==$j) {
            my $p = comb($i);
            my $q = comb($k);
            $total_comb += H($p,2)*$q;
            #print_debug($i, $j, $k, "i,j same ==== ".H($p,2)*$q);
        }
        elsif ($j==$k) {
            my $p = comb($i);
            my $q = comb($k);
            $total_comb += $p*H($q,2);
            #print_debug($i, $j, $k, "j,k same ==== ".$p*H($q,2));
        }
        else {
            my $p = comb($i);
            my $q = comb($j);
            my $r = comb($k);
            $total_comb += $p*$q*$r;
            #print_debug($i, $j, $k, "all different ==== ".H($p,2)*$q);
        }
    }
}

print $total_comb, "\n";
=pod
for my $i (1..10) {
    print "comb($i) = ". comb($i),"\n";
    print "divisors($i) = ".join(",", divisors($i)), "\n";
}
=cut

sub print_debug {
    my ($i,$j,$k,$comment) = @_;
    
    print <<DEBUG;
i=$i, j=$j, k=$k  $comment
DEBUG

}

sub comb {
    my $x = shift;
    return 1 if $x==1;

    my $ret = 0;
    my @divisors = divisors($x);
    foreach my $i (reverse @divisors) {
        my $y = $x/$i;

        map {++$ret;}
        grep {$_ >= sqrt($y) && $i >= $_}
        divisors($y);
    }
    
    return $ret;
}

sub divisors {
    my $m = shift;
    
    my @ret = (1);
    my $_sq_m = sqrt($m);
    for (my $i=2; $i<=$_sq_m; $i++) {
        push(@ret, $i) unless ($m % $i);
    }
    foreach my $i (reverse @ret) {
        next if ($i == $_sq_m);
        push(@ret, $m/$i);
    }
    
    return @ret;
}

sub H {
    my ($h, $r) = @_;
    return C($h+$r-1, $r);
}

sub C {
    my ($c, $r) = @_;
    return 1 if $c == $r || $r == 0;
    
    my $m = $c-$r >= $r ? $r : $c-$r;
    my $ret = 1;
    
    for (my $i=$c; $i>$c-$m; --$i) {
        $ret *= $i;
    }
    for (my $i=$m; $i>1; --$i) {
        $ret /= $i;
    }
    
    return $ret;
}