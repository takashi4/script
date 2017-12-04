#!/usr/bin/env perl

use strict;
use warnings;

use Memoize;
memoize('_div_str');

chomp(my $arg = <>);

print _div_str($arg), "\n";

sub _div_str {
    my ($str) = @_;
    
    my $count = 0;
    my $len = length $str;
    if ($len == 0) {return 1 ;}
    if ($len == 1) {return 0 ;}
    if ($len == 2 || $len == 3) {
        return 1 if (_is_kaibun($str));
        return 0;
    }
    for (my $l=2; $l <= $len; ++$l) {
        my $s = substr($str, 0, $l);
        if (_is_kaibun($s)) {
            $count += _div_str( substr($str, $l, $len) );
        }
    }
    
    return $count;
}

sub _is_kaibun {
    my $str = shift;
    return $str eq reverse $str;
}

my $timer;
sub Timer::start {
    $timer = Time::HiRes::time();
}
sub Timer::stop {
    Time::HiRes::time() - $timer;
}
sub Timer::wrap {
    my $now = Time::HiRes::time(); 
    my $ret = $now - $timer;
    $timer = $now;
    return $ret;
}