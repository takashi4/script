#!/usr/bin/env perl

use strict;
use warnings;

use Time::HiRes;
use Memoize;
#memoize('_is_kaibun');

use YAML;
use Readonly;

Readonly my $OK => q{__OK__};
Readonly my $NG => q{__NG__};

chomp(my $arg = <>);

my %hash = ();
my $count = 0;

Timer::start();
_div_str($arg,\%hash);
print Timer::wrap(), "\n";

#_print_hash(\%hash, []);

#_count_hash(\%hash, []);
print $count, "\n";

sub _count_hash {
    my ($h,$arr) = @_;
    
    foreach my $k (keys %$h) {
        if ($k eq $OK) {
           ++$count; 
        }
        elsif ($k ne $NG) {
            _count_hash($h->{$k}, [@$arr, $k]);
        }
    }
}

sub _print_hash {
    my ($h,$arr) = @_;
    
    foreach my $k (keys %$h) {
        if ($k eq $OK) {
#_print_debug($k, $arr, q{OK});
            print join(q{/}, @$arr), "\n";
        }
        elsif ($k ne $NG) {
#_print_debug($k, $arr, q{NG});
            _print_hash($h->{$k}, [@$arr, $k]);
        }
    }
}

sub _print_debug {
    my ($key, $arr, $comment) = @_;
    my $dump = Dump $arr;
    print <<DEBUG;
$comment:$key
$dump    
DEBUG

}
sub _div_str {
    my ($str, $h) = @_;
    
    my $len = length $str;
    if ($len == 0) { $h->{$OK} = 1; ++$count; return;}
    if ($len == 1) { $h->{$NG} = 1; return;}
    if ($len == 2 || $len == 3) {
        if (_is_kaibun($str)) {
            $h->{$OK} = 1; ++$count; return;
        }
        else {
            $h->{$NG} = 1; return;
        }
        
    }
    for (my $l=2; $l <= $len; ++$l) {
        my $s = substr($str, 0, $l);
        if (_is_kaibun($s)) {
            _div_str( substr($str, $l, $len), ($h->{$s} = {}) );
        }
    }
}

sub _is_kaibun {
    my $str = shift;
#    print $str,"\n";
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