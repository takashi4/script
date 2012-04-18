package TT::TIME;

use strict;
use Carp::Clan;
use Time::Local;
use Exporter qw(import);
our @EXPORT_OK = qw(
	yyyy_mm_dd_hh_mm  ep_time
);

sub ep_time {
	my $ymd    = shift or return();
	my $regexp = shift || qr{(\d\d\d\d)(\d\d)(\d\d)}o;
	croak 'invalid regexp' if (ref $regexp ne 'Regexp');

	my ($y, $m, $d, $h, $min, $s) =
		$ymd =~ $regexp;
	croak "invalid ymd: $ymd" if (! $y*$m*$d);

	$h ||=0; $min ||=0; $s ||= 0;
	return(
        Time::Local::timelocal($s, $min, $h, $d, $m-1, $y)
	);
}

sub yyyy_mm_dd_hh_mm {
	my $time   = shift || time();
	my $format = shift || '%04d/%02d/%02d %02d:%02d';

	my @t = localtime( $time );
	
	return(
		sprintf($format, $t[5]+1900, $t[4]+1, @t[3,2,1,0])
	);
}
1;
