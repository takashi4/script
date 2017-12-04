#!/usr/bin/env perl

use strict;
no warnings 'all';

use Furl;

my $furl = Furl->new(
  agent => 'MyGreatUA/2.0',
  timeout => 10,
  headers => [
    referer => q{https://nikkei225jp.com/chart/},
  ],
);

my $URL = q{https://jss.nikkei225jp.com/ajax_cme.js};

my $prt_time = '';
while (1) {
  my %ret = _get_info();
  if ($ret{time} && $prt_time ne $ret{time}) {
    $ret{price} =~ s/(\d+).*/$1/;
    print<<OUT;
$ret{time}  $ret{price}  $ret{usdjpy}
OUT
    $prt_time = $ret{time};
  }
  sleep( 10 );
}

sub _get_info {

  my $res= $furl->get(qq{$URL?_=}.time());

  my %ret = ();
  if ($res->is_success()) {
    my $content = $res->content();
    my ($DAISHO1, $DAISHO2, $USDJPY) = $content =~ m!A\[131\]="([^"]+)";\nA\[132\]="([^"]+)".+A\[511\]="([^"]+)"!s;

    # [0] : price
    # [1] : difference
    # [2] : difference%
    # [3] : Time
    # [4] : Flag ?
    my @DAISHO1 = split(q{_}, $DAISHO1);
    my @DAISHO2 = split(q{_}, $DAISHO2);
    my @USDJPY  = split(q{_}, $USDJPY );

    my $usdjpy = "$USDJPY[0]($USDJPY[3])";
    if ($DAISHO1[4]) {
      %ret = (
        time  => $DAISHO1[3],
        price => $DAISHO1[0],
        usdjpy => $usdjpy,
      );
    }
    elsif ($DAISHO2[4]) {
      %ret = (
        time  => $DAISHO2[3],
        price => $DAISHO2[0],
        usdjpy => $usdjpy,
      );
    } 
  }
  return %ret;
}


