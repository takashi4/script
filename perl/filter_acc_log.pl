#!/usr/bin/env perl

use strict;

=pod
LogFormat "%h\t%v\t%p\t%t\t\"%r\"\t%>s\t%b\t\"%{User-Agent}i\"\t\"%{x-jphone-uid}i\"\t\"%{x-up-subno}i\"\t\"%{Referer}i\"\t\"%{x-log-user}o\"\t\"%{x-log-track}o\"\t\"%{X-DCMGUID}i\"\treq_cookie:%{cookie}i\tres_cookie:%{Set-cookie}o"\tgame
=cut

my @needed = qw(
	3  4  15  16
);

my %cookie = (
	15 => 1, #req cookie
	16 => 2, #res cookie
);

while (<>) {
	chomp;
	my @log = split(/\t/);

	print $_."\n" for grep {! $cookie{$_}} @log[@needed];
	print "REQ: $_\n" for map { split(/;/ ) } @log[grep {$cookie{$_} == 1} @needed];
	print "RES: $_\n" for map { split(/,/ ) } @log[grep {$cookie{$_} == 1} @needed];
	print "==================================\n"	
}
