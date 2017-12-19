#!/usr/bin/env perl

# 7   5   2   -> 16
# 29  10  10  -> 92378
# 500 249 125 -> 0
# 123 81  82  -> X 284067 -> timeover
# 436 400 212 -> timeover
# 497 490 399 -> --------

use strict;
use warnings;

use List::Util qw(sum min);
use Memoize;
memoize('G');

use Data::Printer;
my $DIV = 1000003;
chomp(my $args = <>);

my ($n,$a,$b) = split(/\s+/, $args);

print F($n,$a,$b)%$DIV, "\n";
#print F($n,$a,$b), "\n";

sub F {
    my ($n,$a,$b) = @_;
    
    my $min_b = $n-$a<=0 ? 0 : int( ($n-$a+1) / 2 );
    my $max_b = min($b, int($n/2));

    return 0 if ($max_b < $min_b);
print "min_b: $min_b\n";
print "max_b: $max_b\n";
    return sum( map{G($n,$_)} ($min_b..$max_b) );
}

sub G {
    my ($_n, $_b) = @_;
    
    if ($_n<2) {return 0;}
    elsif ($_n < 2*$_b) {return 0;}
    elsif ($_n == 2*$_b) {return 1;}
    elsif ($_b == 0) {return 1;}
    elsif ($_b == 1) {return $_n-1;}
    else {
        my $__b = $_b-1;
        return sum( map{G($_, $__b)} ((2*$__b)..($_n-2)) )%$DIV;
    }
}