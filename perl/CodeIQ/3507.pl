#!/usr/bin/env perl

#70 -> 5
#100 -> 11
#543 -> X 252 O 144
#1234 -> overtime -> 240
#3000 -> --- -> 1

use strict;
use warnings;

use List::Util qw(sum max);

#use Data::Printer {multiline => 0};
#use Time::HiRes qw(time);

my @STAMPS = qw(
    1 2 3 5 10 20 30 50 62 82 92 
    100 120 140 205 280 310 500 1000
);

chomp(my $n = <>);

my @limit = ();

=pod
@limit = ( 1, 3, 6, 11, 21, 41, 71, 121, 183, 265, 357,
           457, 577, 717, 922, 1202, 1512, 2012, 3012 )
=cut
my @need = ();
for (my $i=0; $i<@STAMPS; ++$i) {
    $limit[$i]=sum(@STAMPS[0..$i]);
    push(@need, $i) if ($limit[$i] > $n && $STAMPS[$i] <= $n);
}

# １円の場合
if (! @need) { print 1, "\n"; exit; }
my $i = 0;

my @need_comb = _make_need_comb();
my %need_numbers = map { map{$need[$_]=>1} @$_} @need_comb;

#p%need_numbers;
my $count=0;
foreach my $_need (@need_comb) {
    my $rest = $n - sum(map {$STAMPS[$need[$_]]} @$_need);
    
#    print "========== ".join(',', map {$STAMPS[$need[$_]]} @$_need)." ==========\n";
    
#    print <<DEBUG;
#====== rest: $rest =========
#DEBUG
    ++$count, next if $rest == 0;
#p$_need;
    my @not_need = 
        grep {! defined $need_numbers{$_} }
        grep {$STAMPS[$_] <= $rest && $need[$_need->[0]]>$_}
        (0..$#STAMPS);
#p@not_need;
    for (my $j=1; $j<2**@not_need; ++$j) {
        my $_rest = 0;
        my $_j = $j;
        my $k = 0;
        while ($_j>0) {
            $_rest += $STAMPS[$not_need[$k]] if $_j%2;
            $k++;
            $_j >>=1;
        }
#        print(<<DEBUG), ++$count if ($_rest == $rest);
#====== _rest($j): $_rest =========
#DEBUG
        ++$count if ($_rest == $rest);
    }
}

print $count,"\n";

sub _make_need_comb {
    my $i = scalar @need;
    my @ret = ();
    
    for (my $j=1; $j<2**$i; ++$j) {
        my @_ret = ();
        my $_j = $j;
        my $last_flg=0;
        for (my $k=0; $k<$i; ++$k) {
            if ($_j%2) {
                my $sum = sum(map {$STAMPS[$need[$_]]} @_ret) || 0;
                $last_flg=1, last if ($n<$sum+$STAMPS[$need[$k]]);
                push(@_ret, $k);
            }
            
            $_j >>= 1;
        }
        push(@ret, \@_ret) unless $last_flg;
    }
    
    return @ret;
    
}
