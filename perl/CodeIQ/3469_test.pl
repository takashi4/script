#!/usr/bin/env perl

use strict;
use warnings;

use YAML qw(Dump);

chomp(my $arg = <>);
my ($X, $Y, $N) = split(/\s+/, $arg);

($X,$Y,$N)=(4,3,5);
my @maps;
push(@maps, [
    [undef,undef,undef,1],
    [undef,undef,undef,1],
    [1,undef,undef,undef],
]);
print "NG(3,0)" if _invalid_point(3,0,$maps[0]);
print "NG(3,1)" if _invalid_point(3,1,$maps[0]);
print "NG(0,2)" if _invalid_point(0,2,$maps[0]);
print "_is_no" if _is_no($maps[0]);
=pod
foreach my $map (@maps) {
    next if _is_no($map);
    my $len = promote(0,0, @$map);
    next if $len != $N;
    print "=================================\n";
    printMap(@$map);
    print "=================================\n";
}
=cut
# 任意の個数の工事交差点を作成
sub _loop {
	my ($i,$j,$h, $m)=@_;
	if ($j == $m) {
		push(@maps, makeMap(
			map { $h->{$_} } (0..($X*$Y - 1))
		));
		return;
	}

	for (my $k=1+$i; $k<$X*$Y - $m + $j; ++$k) {
		$h->{$k} = 1;
		_loop($k, $j+1, $h, $m);
		delete $h->{$k};

		$h = {} if ($j==0);
	}
}
 
#linear -> 2-D transform
sub makeMap {
    my @a = @_;
    
    my @ret;
    while (@a) {
        my @row = splice(@a, 0, $X);
        push(@ret, \@row);
    }
    
    return \@ret;
}

sub promote {
    # ( [undef,1,undef,undef,,undef], [,,,,] )
    my ($x, $y, @map) = @_;
    
    my $max_x = $#{$map[0]};
    my $max_y = $#map;
    my $count=0;
    return 1 if ($x == $max_x && $y == $max_y);
    
    # go EAST
    if ($x < $max_x && ! defined $map[$y][$x+1]) {
        $count += promote($x+1, $y, @map);
    }
    
    # go SOUTH
    if ($y < $max_y && ! defined $map[$y+1][$x]) {
        $count += promote($x, $y+1, @map);
    }
    
    return $count;
          
}

#指定された点から、始点・終点に帰れること
sub _invalid_point {
    my ($i,$j,$map) = @_;
    return 1 unless _can_promote($i,$j,$map);
    return 1 unless _can_demote($i,$j,$map);
    
    #valid point
    return 0;
}

sub _can_demote {
    my ($x, $y, $map) = @_;
    
    my $min_x = 0;
    my $min_y = 0;
    
    return 1 if ($x == $min_x && $y == $min_y);
    
    my ($_can_west, $_can_north);
    
    #go WEST
    $_can_west = _can_demote($x-1, $y, $map)
        if ($x > $min_x && ! defined $map->[$y][$x-1]);
    
    # go NORTH
    $_can_north = _can_demote($x, $y-1, $map)
        if ($y > $min_y && ! defined $map->[$y-1][$x]);
    
    # NG
    return $_can_west || $_can_north;
}
sub _can_promote {
    my ($x, $y, $map) = @_;
    
    my $max_x = $#{$map->[0]};
    my $max_y = $#$map;
    
    return 1 if ($x == $max_x && $y == $max_y);
    
    my ($_can_east, $_can_south);
    
    #go EAST
    $_can_east = _can_promote($x+1, $y, $map)
        if ($x < $max_x && ! defined $map->[$y][$x+1]);
    
    # go SOUTH
    $_can_south = _can_promote($x, $y+1, $map)
        if ($y < $max_y && ! defined $map->[$y+1][$x]);
    
    # NG
    return $_can_east || $_can_south;
}

sub _is_no {
    my $map = shift;
    
    for (my $j=0; $j<@$map; ++$j) {
        for (my $i=0; $i<@{$map->[$j]}; ++$i) {
print <<DEBUG;
i = $i  j = $j
DEBUG
            return 1 if defined $map->[$j][$i] && _invalid_point($i,$j,$map);
        }
    }
    
    
    return 0;
}


sub printMap {
    my @map = @_;
    
    map {print( join( q{------}, map {defined $_ ? q(X) : q(O)} @$_ ), "\n" );} @map
}
