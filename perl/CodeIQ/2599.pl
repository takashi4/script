#!/usr/bin/env perl

use strict;
use warnings;

my $ERR_SYNTAX = q{Unknown syntax};
my $ERR_NAME   = q{Unknown name};

chomp(my $input = <>);

if (my $err = _check_err($input)) {
    print $err,"\n";
}
else {
    $input =~ s/two/two()/g;

    my $output = eval $input;
    if ($@) {
        print $ERR_SYNTAX,"\n";
    }
    else {
        print $output,"\n";
    }
}

sub two {2};
sub mod {
    $_[0] % $_[1];
}
sub sumsq {
    my $ret = 0;
    while (my $arg = shift @_) {
        die unless defined $arg;
        $ret += $arg*$arg;
    }
    return $ret;
}
sub _check_err {
    my $inp = shift;
    
    return $ERR_NAME unless $inp =~ /^[-\d+*twomdsuq(),]+$/;
    return $ERR_NAME if $inp =~ /[a-z]+/ && $inp !~ /\b(two|sumsq|mod)\b/;
    return $ERR_SYNTAX if $inp =~ /,,/;
    return;
    
    
}