#!/usr/bin/env perl

use strict;

my ($m, $n, $dummy) = split(/\s+/, <>);

my @node = ();

make_node();
print search($n, $node[1]);

sub make_node {
  for (my $i=1; $i <= $m; $i++) {
    my $p = int($i/2);
    my $q = $i%2;
    $node[$i] = {val => $i};
    next if $p == 0;

    if ($q == 0) {
      $node[$p]{l} = $node[$i];
    } else {
      $node[$p]{r} = $node[$i];
    }
  }
}

sub search {
  my ($j, $now) = @_;
  
  return $now->{val} if $j == 1;
  
  my $c = count($now->{l});
  if ($j <= $c+1) {
    return search($j-1, $now->{l});
  } else {
    return search($j-$c-1, $now->{r});
  }
}

sub count {
  my $now = shift;
  return 1 if !$now || (!$now->{l} && !$now->{r});
  
  my $ret = 1;
  $ret += count($now->{l}) if $now->{l};
  $ret += count($now->{r}) if $now->{r};
  return $ret;
}


