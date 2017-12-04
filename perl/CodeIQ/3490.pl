#!/usr/bin/env perl

use strict;
use warnings;

chomp(my $m = <>);

unless ($m % 2) {
    print "invalid\n";
    exit;
}

my @result;

for (my $R=0; $R<$m; ++$R) {
    my $row = _get_row($R);
    push(@result, $row);
}

map {
    map {print(defined $_ ? q(m) : q(.))} @$_;
    print "\n";
} @result;

sub _get_row {
    my $r = shift;
    if ($m==1) {return [1];}

    my @row;
    $row[0] = $row[$m-1] = 1;
    if (0<$r && $r<($m-1)/2) {
        $row[$r] = $row[$m-1-$r] = 1;
    }
    elsif ($r == ($m-1)/2) {
        $row[$r] = 1;
    }
    
    return \@row;
}
