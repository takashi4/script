#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;

my ($n, $OPOS, $XPOS, $_dummy) = split(/\s+/, <>);
my @O = split(/,/, $OPOS);
my @X = split(/,/, $XPOS);

my $all_pos = make_comb(\@O, $n);
my $all_area = make_area($all_pos);

my $result = 0;
for my $area (@$all_area) {
  # areaにXを含んでたらアウト
  next if check_X($area);
  # areaに含まれるOが規定外ならアウト
  next if !check_O($area, $n);
  
  # 含まれないXOを集める
  my @exclude_pos = grep {! check_include($area, $_) } @O, @X;

  # areaを上に伸ばしたときの最大面積
  my $result_upper = get_edge_upper(\@exclude_pos, $area);
  result = $result_upper if ($result_upper > $result);
  # areaを左に伸ばしたときの最大面積
  my $result_left = get_edge_left(\@exclude_pos, $area);
  result = $result_left if ($result_left > $result);
  # areaを右に伸ばしたときの最大面積
  my $result_right = get_edge_right(\@exclude_pos, $area);
  result = $result_right if ($result_right > $result);
  # areaを上に伸ばしたときの最大面積
  my $result_bottom = get_edge_bottom(\@exclude_pos, $area);
  result = $result_bottom if ($result_bottom > $result);
}
$result ||= q{-};
print $result;

sub get_edge_upper {
  my ($ex_pos, $area) = @_;

  my $upper = substr($area->[0], 0, 1);
  my $left = substr($area->[0], 1, 1);
  
  map {
    my $u = substr($_->[0], 0, 1);
    grep {$left > substr($_->[0], 1, 1)	} @$ex_pos;
  }
  grep {$upper > substr($_->[0], 0, 1)} @$ex_pos;
}

sub calc_area {
  my $area = shift;
  
  my $xd = ord(substr($area->[1], 0, 1)) - ord(substr($area->[0], 0, 1) + 1;
  my $yd = ord(substr($area->[1], 1, 1)) - ord(substr($area->[0], 1, 1) + 1;
  return $xd*$yd;
}

sub check_X {
  my $area = shift;
  foreach my $pos_X (@X) {
    return if check_include($area, $pos_X);
  }
  
  return 1;
}
sub check_O {
  my ($area, $m) = @_;
  my $num_O = 0;
  foreach my $pos_O (@O) {
    $num_O++ if check_include( $area, $pos_O );
  }
  
  return $num_O == $m;
}

sub check_include {
  my ($area, $pos) = @_;
  my ($min_x, $min_y) = get_xy($area->[0]);
  my ($max_x, $max_y) = get_xy($area->[1]);
  my ($x, $y) = get_xy($pos);
  
  return $min_x <= $x && $x <= $max_x && $min_y <= $y && $y <= $max_y;
}

sub make_area {
  my $pos_included = shift;
  my ($min_x, $max_x, $min_y, $max_y) = qw( Z A z a );

  foreach my $pos (@$pos_included) {
    my ($x, $y) = get_xy($pos);
    if ($x < $min_x) {$min_x = $x}
    if ($x > $max_x) {$max_x = $x}
    if ($y < $min_y) {$min_y = $y}
    if ($y > $max_y) {$max_y = $y}
  }
  return ($min_x == $max_x || $min_y == $max_y) ? []
                                                : [$min_x+$min_y, $max_x+$max_y]
                                                ;
}

sub get_xy {
  split('', shift);
}
sub get_x {
  my $xy = shift;
  return substr($xy, 0, 1);
}
sub get_y {
  my $xy = shift;
  return substr($xy, 1, 1);
}


sub make_comb {
  my ($lis, $m) = @_;
  return [[]] if $m == 0;
  
  my @ret = ();
  for (my $i=0; $i<(@$lis - $m+1); $i++) {
    foreach my $arr (@{make_comb(_slice($lis, $i), $m-1)}) {
      push(@ret, [$lis->[$i], @$arr]);
    }
  }
  return [@ret];	
}

sub _slice {
  my ($arr, $j) = @_;
  my @arr = @$arr;
  shift @arr for (0..$j);
  return [@arr];
}
