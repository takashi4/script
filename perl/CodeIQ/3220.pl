#!/usr/bin/env perl

use strict;
use warnings;
use Time::Local;

while (<>) {
  chomp;
  my ($yyyy, $mm, $d) = split(/,/);
  my $t = $mm == 12 ? timelocal(0,0,0, 1, 0,   $yyyy+1)
                    : timelocal(0,0,0, 1, $mm, $yyyy  )
                    ;
  my $wday = (localtime($t))[6];
  # 翌月の初曜日
  my $dd = $wday > $d ? 7  - $wday + $d +1
                      : $d - $wday      +1
                      ;
  my $T = $mm == 12 ? timelocal(0,0,0, $dd, 0,   $yyyy+1)
                    : timelocal(0,0,0, $dd, $mm, $yyyy  )
                    ;
  
  my ($YYYY, $MM, $DD) = (localtime($T - 7*24*60*60))[5,4,3];
  
  printf("%04d", $YYYY+1900);
  printf("%02d", $MM+1);
  printf("%02d\n", $DD);
}
  
  
   
  