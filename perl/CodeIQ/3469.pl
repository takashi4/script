#!/usr/bin/env perl

use strict;
use warnings;

use YAML;

chomp(my $arg = <>);
my ($X, $Y, $N) = split(/\s+/, $arg);

=pod
my $result = promote(0,0,
    #(\@row, \@row, \@row)
    (
        [undef, undef, undef, undef],
        [undef, undef, undef, 1],
        [1,      undef, undef, undef]
    )
    
);
print $result, "\n";
=cut
  
my @maps = makeMap2();
foreach my $map (@maps) {
    my $len = promote(0,0, @$map);
    next if $len != $N;
    print "=================================\n";
    printMap(@$map);
    print "=================================\n";
}

# ２つの工事交差点を作成
sub makeMap2 {
    my @maps;
    for (my $li1=1; $li1 < $X*$Y - 2; ++$li1) {
        for (my $li2=$li1+1; $li2 < $X*$Y - 1; ++$li2) {
           my @a;
           undef $a[$X*$Y-1];
           $a[$li1] = $a[$li2] = 1;
           push( @maps, makeMap(@a) );
        }
    }
    return @maps;       
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
sub makeCoord {
    my ($x,$y) = @_;
    return $X*$y + $x;
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

sub printMap {
    my @map = @_;
    
    map {print( join( q{------}, map {defined $_ ? q(X) : q(O)} @$_ ), "\n" );} @map
}