#!/usr/bin/env perl

use strict;
use warnings;

use YAML;

my $n = 5;
==pod
期待する結果
$i: _make_maps の引数
    $i=1; [[0]]
    $i=2; [[0,1],[0,2],[0,3],[0,4]]
    $i=3; [[0,1,2],[0,1,3],[0,1,4],[0,2,3],[0,2,4],[0,3,4]]
    $i=4; [[0,1,2,3],[0,1,2,4],[0,1,3,4],[0,2,3,4]]
    $i=5; [[0,1,2,3,4]]
]
==cut

for (my $i=1; $i<=$n; ++$i) {
    print "============= _make_maps($i) ==============\n";
    print Dump [_make_maps($i)];
}

sub _make_maps {
    my $m = shift;
    
    my @ret;
    _loop_by_nest(\@ret, $m, []);
    return @ret;
}

sub _loop_by_nest {
    my ($arr, $m, $acc) = @_;
    --$m;
    my $acc_num = scalar @$acc;
    
    if ($m == $acc_num) {
        unshift( @$acc, 0 );
        push(@$arr, $acc);
        return;
    }
    else {
        my $init = $acc_num ? $acc->[-1]+1 : 1;
        for (my $i=$init; $i<
    }
}


