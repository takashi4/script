#!/usr/bin/env perl

use strict;
use warnings FATAL => qw(all);
use Data::Dumper qw(Dumper);

my $WIN     = 0.6;
#my $WIN     = 0.5;
my $RATE    = 2;
my $HAVE    = 1000000;
my $MAX_TRY = 100;
my $SAMPLE_NUM = 100000;

#print Dumper rot(shift);

#for (my $rot = 10000; $rot <= $HAVE; $rot += 10000) {
for my $rot (qw(10000 20000 30000 100000 200000 500000 1000000)) {
	my $ret = 0;
	my $bankruptcy = 0;
	for (1..$SAMPLE_NUM) {
		my $hash = rot($rot);
		$ret += $hash->{have};
		$bankruptcy++ if $hash->{have} <= $rot;
	}
	my $ave = $ret / $SAMPLE_NUM;
	print <<RESULT;
$rot	$ave	$bankruptcy/$SAMPLE_NUM
RESULT
}

sub rot {
	my $k = shift;
	my $have = $HAVE;

	my $count = 0;
	while ($have >= $k) {
		$count++;
		$have -= $k;

		$have += $k*$RATE if (rand() <= $WIN);
		last if ($count == $MAX_TRY);
	}
	return { have => $have, count => $count }
}
