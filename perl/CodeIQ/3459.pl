#!/usr/bin/env perl

# 7   5   2   -> 16
# 29  10  10  -> 92378
# 500 249 125 -> 0
# 123 81  82  -> 475012(1sec)
# 436 400 212 -> timeover(544100 50sec) -> OK
# 497 490 399 -> timeover(663760 72sec) -> OK

use strict;
use warnings;

#use Data::Printer {multiline=>0};

use List::Util qw(sum min);
use Memoize;
memoize('G');

my $DIV = 1000003;
chomp(my $args = <>);

my %counter = ();

my ($n,$a,$b) = split(/\s+/, $args);

#print "====== G($n,$b) =========",G($n,$b),"\n";

print F($n,$a,$b)%$DIV, "\n";
#p%counter;
sub F {
    my ($n,$a,$b) = @_;
    
    my $min_b = $n-$a<=0 ? 0 : int( ($n-$a+1) / 2 );
    my $max_b = min($b, int($n/2));

    return 0 if ($max_b < $min_b);
    return sum( map{G($n,$_)} ($min_b..$max_b) );
}

=pod
G(n,b) = ∑i_1(1..l)∑i_2(1..i_1)・・・∑1(1..i_b) 
l = n-2b+1

漸化式
G(n,b) = G(n-1,b) + G(n-2,b-1)
=cut
sub G {
    my ($_n, $_b) = @_;
++$counter{$_n}{$_b};
    if ($_n<2) {return 0;}
    elsif ($_n < 2*$_b) {return 0;}
    elsif ($_n == 2*$_b) {return 1;}
    elsif ($_b == 0) {return 1;}
    elsif ($_b == 1) {return $_n-1;}
    else {
        my $__b = $_b-1;
#        return sum( map{G($_, $__b)} ((2*$__b)..($_n-2)) )%$DIV;
        return (G($_n-1,$_b) + G($_n-2, $_b-1))%$DIV;
    }
}