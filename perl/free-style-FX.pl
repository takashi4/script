#!/usr/bin/env perl

use strict;
use warnings FATAL => qw(all);

use Math::Counting qw( combination );
use POSIX qw( ceil );

my $win = 0.6;

print f(100);



sub f {
	my $k = shift;
	my $m = ceil( 100*($k - 1)/3/$k );

	my $result = 0;
	for (my $l=$m; $l<=100; $l++) {
		$result += combination( 100, $l )*$win^$l*(1-$win)^(100-$l)*(3*$k*$l + 100*(1 - $k));
	}

	return $result;
}


