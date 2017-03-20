#!/usr/bin/perl
# 使い方
# echo -n '\343\203\207\343\203\274\343\202\277\343\201\214\347\204\241\345\212\271\343\201\247\343\201\231\343\200\202'
# | perl oct2utf8.pl

use strict;

my @t = split(qr{\\}, <>);

shift @t;
my $s = join(q{}, map {sprintf(q{%x}, oct)} @t);
print( pack(q{H*}, $s) ); 

