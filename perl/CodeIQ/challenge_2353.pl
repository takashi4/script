#!/usr/bin/env perl

use strict;
use warnings;
use YAML;
use List::Util qw(sum);

chomp(my $yourP = <>);
my @cards = ();
while (<>)
{
  chomp();
  push(@cards, $_);
}

@cards = sort {$a <=> $b} @cards;

my $counter = 0;
$counter++ if (sum(@cards) > $yourP);

for (my $i=0; $i<@cards; $i++)
{
  my @tmp_cards = @cards;
  splice(@tmp_cards, $i, $i+1);
