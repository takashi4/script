#!/usr/bin/env perl

use strict;
#use warnings;

#n 個のマスがあり、左側から a マスには右に進むa匹のカエルが、右側から b マスには左に進むb匹のカエルがいます。
#1つのマスには1匹のカエルしか入れられず、一度に1匹のカエルを移動します。
#この操作を行い、最短の回数で移動するときの移動回数を求めてください。
#なお、それぞれの向きのカエルを交互に移動する必要はありませんので、どちらから始めても構いませんし、
#同じ向きのカエルを連続して動かしても構いません。
#5 2 2 → 8
#8 2 5 → 17
#10 3 3 → timeover（メモ化で解決）33
#12 4 5 → timeover（メモ化で解決）47
#14 6 6 → timeover（メモ化＆参照渡しに変更で解決）60


use Memoize;
memoize(q{_moves});

#use Data::Printer {multiline=>0};

chomp(my $args = <>);
my ($N, $A, $B) = split(/\s+/, $args);
#my $BLACK = "▼";
#my $WHITE = "△";
my $BLACK = "X";
my $WHITE = "Y";
my %count;
my @complete_WHITE = ($WHITE) x $B;
my $complete_WHITE = "@complete_WHITE";
my @complete_BLACK = ($BLACK) x $A;
my $complete_BLACK = "@complete_BLACK";

my @places = (($BLACK) x $A, (undef) x ($N-$A-$B), ($WHITE) x $B);

my $result = _moves(0, @places);
print(defined $result ? "$result\n" : "can't resolve\n");
#p%count;
sub _moves {
#$count{(caller 0)[3]}++;
    my ($acc, @_places) = @_;
    if (_is_complete(\@_places)) {
#print "complete!($acc)\n";
        return $acc;
    }

    my $ret;
#print "   "x$acc,"=== loop ===\n";
    foreach my $j (grep {defined $_places[$_]} (0..$#_places)) {
#    for (my $j=0; $j<$N; ++$j) {
#        if (_is_movable($j, @_places)) {
        if (my $__places = _move_one_if_ok($j, \@_places)) {
            #my ($_acc, @__places) = _move_one($j, @_places);
#            my @__places = _move_one($j, @_places);
            #my $_ret = _moves($acc+$_acc, @__places);
            my $_ret = _moves($acc+1, @$__places);
            next unless defined $_ret;
            
            $ret = $_ret if (!defined $ret || $ret > $_ret);
        }
    }
    #print "no way\n" unless (defined $ret);
    return $ret;
}

sub _is_complete {
#$count{(caller 0)[3]}++;
    my $_places = shift;
    
    return 0 unless ("@{$_places}[0..($B-1)]" eq $complete_WHITE);
    return 0 unless ("@{$_places}[($N-$A)..($N-1)]" eq $complete_BLACK);
    
    return 1;
}
sub _move_one_if_ok {
    my ($i, $_places) = @_;

    if ($_places->[$i] eq $BLACK) {
        if ($i<$N-1 && ! defined $_places->[$i+1]) {
            my @_places = @$_places;
            $_places[$i+1] = $BLACK;
            undef $_places[$i];
            return \@_places;
        }
        elsif ($i<$N-2 && $_places->[$i+1] eq $WHITE && ! defined $_places->[$i+2]) {
            my @_places = @$_places;
            $_places[$i+2] = $BLACK;
            undef $_places[$i];
            return \@_places;
        }
            
    }
    elsif ($_places->[$i] eq $WHITE) {
        if ($i>0 && ! defined $_places->[$i-1]) {
            my @_places = @$_places;
            $_places[$i-1] = $WHITE;
            undef $_places[$i];
            return \@_places;
        }
        elsif ($i>1 && $_places->[$i-1] eq $BLACK && ! defined $_places->[$i-2]) {
            my @_places = @$_places;
            $_places[$i-2] = $WHITE;
            undef $_places[$i];
            return \@_places;
        }
    }
    
    return;
}

sub _move_one {
#$count{(caller 0)[3]}++;
    my ($i, @_places) = @_;
    my $_acc = 1;
    if ($_places[$i] eq $BLACK) {
        if ($_places[$i+1] eq $WHITE) {
            $_places[$i+2] = $BLACK;
#print $BLACK,"($i→".($i+2),")\n";
        }
        else {
=pod
            for (my $j=$i+2; $j<$N; ++$j) {
                last if defined $_places[$j];
                ++$_acc;
            }
=cut
            $_places[$i+$_acc] = $BLACK;
#print $BLACK,"($i→".($i+1),")\n";
        }
    }
    else {
        if ($_places[$i-1] eq $BLACK) {
            $_places[$i-2] = $WHITE;
#print $WHITE,"($i→".($i-2),")\n";
        }
        else {
=pod
            for (my $j=$i-2; $j>=0; --$j) {
                last if defined $_places[$j];
                ++$_acc;
            }
=cut
            $_places[$i-$_acc] = $WHITE;
#print $WHITE,"($i→".($i-1),")\n";
        }
    }
    
    undef $_places[$i];
#    return ($_acc, @_places);
    return @_places;
}

sub _is_movable {
#$count{(caller 0)[3]}++;
    my ($i, @_places) = @_;
    if ($_places[$i] eq $BLACK) {
        return 1 if (
            ($i<$N-1 && ! defined $_places[$i+1])
            || ($i<$N-2 && $_places[$i+1] eq $WHITE && ! defined $_places[$i+2])
        );
    }
    elsif ($_places[$i] eq $WHITE) {
        return 1 if (
            ($i>0 && ! defined $_places[$i-1])
            || ($i>1 && $_places[$i-1] eq $BLACK && ! defined $_places[$i-2])
        );
    }
    
    return 0;
}
