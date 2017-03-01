#!/usr/bin/env perl

use strict;
use warnings;

while (<>) {
	chomp;
	my @sorted_numbers = sort { $a <=> $b } split("");
	print $sorted_numbers[0] ? $sorted_numbers[$#sorted_numbers] : $sorted_numbers[1];
	print "\n";
}
