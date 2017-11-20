#!/usr/bin/env perl

use strict;
use warnings;

use Memoize;
#memoize qw(lS comb comb1);

# k段目の上面積 S_k 短辺 L_k は以下を満たす
# k^2 =< S_k =< n - 1/6k(k-1)(2k-1) 
# k =< L_k =< L_k+1 - 1

my %h = {};
while (<>) {
    chomp;
    my ($m, $n) = split;
    my @a = ();
    my $count = 0;
    if ($m == 1) {
        $count =  comb1($n, $n, $n);
    }
    else {
        for (my $l1 = $m; $n/$l1 >=$m ; ++$l1) {
            for (my $l2 = $m; $n - $l1*$l2 >= lS($m-1); ++$l2) {
                my $c = comb ($l1-1, $l2-1, $n - $l1*$l2, $m-1);
                $count += $c;
            }
        }
    }
    
    print <<RESULT;
m=$m  n=$n
result: $count
RESULT
    undef %h;
}

sub comb1 {
	my ($L1, $L2, $S) = @_;
print <<DEBUG;
L1=$L1 L2=$L2 S=$S
DEBUG
    # $S の約数のうち $L1, $L2 以下のもの
    my @divisors = getDivisors($S);
print join(" ", grep {$_ <= $L1 && $S/$_ <= $L2} @divisors);
print "\n";
    return scalar(grep {$_ <= $L1 && $S/$_ <= $L2} @divisors)
}

sub comb {
    my ($L1, $L2, $S, $k) = @_;
print <<DEBUG;
comb called in (L1=$L1, L2=$L2, S=$S, k=$k)
DEBUG
    if ($L1<$k || $L2<$k || $S<lS($k) || $k<=0) {
        return 0;
    }
    elsif ($k==1) {
        if ($L1<1 || $L2<1) {return 0;}

        return comb1($L1, $L2, $S);
    }

    my $maxS = $S  - lS($k-1);

    my $count = 0;
    
    for (my $l1 = $L1; $l1 >= $k ; --$l1) {
        for (my $l2 = $L2; $l2 >= $k ; $l2--) {
            next if ($l1*$l2 > $maxS);
            
            my $c = comb($l1-1, $l2-1, $S - $l1*$l2, $k-1);
            $count += $c;
            if ($c > 0) {
                print <<DEBUG2
l1=$l1 l2=$l2 c=$c k=$k S=$S
DEBUG2
            }
        }
    }
    
    return $count;
}

sub getDivisors {
    my $x = shift;
    my @ret = grep {$x%$_ == 0} (1..$x/2);
    return( @ret, $x );
}
sub lS {
  my $k = shift;
  return $k*($k+1)*(2*$k+1)/6;
}
