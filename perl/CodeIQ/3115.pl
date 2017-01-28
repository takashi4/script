#!/usr/bin/env perl

use strict;
use warnings;

while (<>) {
	my @sorted_numbers = sort { $a <=> $b } split;
	if ($sorted_numbers[0]) {
		print $sorted_numbers[$#sorted_numbers];
	} else {
		print $sorted_numbers[1];
	}
	print "\n";
}
