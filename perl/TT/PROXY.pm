package TT::PROXY;

use strict;
use URI;
use YAML;

use LWP;
use HTTP::Request::Common qw(GET POST);
use Web::Scraper;
use Cache::FileCache;
use List::AllUtils qw( shuffle );

my $URL = q{http://www.cybersyndrome.net/pla5.html};
my $UA  = 'Mozilla/5.0 (Linux; U; Android 2.3.5; ja-jp; F-05D Build/F0001) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1';
my $TTL = 60*60;

my $PROXY_KEY     = 'proxy';
my $BLACK_KEY     = 'black';
my $PROXY_TIMEOUT = 5;

my $fcache  = Cache::FileCache->new({
	namespace => __PACKAGE__,
});
my $scraper = scraper {
	process( '//ol/li/a', 'list[]' => 'TEXT' );
	result( 'list' );
};
my %black_list = ();

$SIG{ALRM} = sub { die 'TIMEOUT' };

sub get_proxy {
	my $proxy;
	my $ip = `hostname --ip-address`; chomp $ip;
	while ( $proxy = _get_proxy() ) {
		eval {
			alarm $PROXY_TIMEOUT;
			my $ua = LWP::UserAgent->new(agent => $UA);
			$ua->proxy( q{http}, "http://$proxy/" );
			my $res = $ua->request( GET("http://$ip/1") );
			die if ($res->content() ne '1');
			alarm 0;
			last;
		};
		alarm 0;
		if (my $err = $@) {
			set_black( host_port => $proxy );
		}
	}

	return( $proxy );
}

sub _get_proxy {
	my $proxy_list = $fcache->get( $PROXY_KEY )
	               || _get_proxy_list();

	map  {return( $_ );           }
	grep {! exists $black_list{$_}}
	shuffle( @$proxy_list );

	die 'ALL BLACKS...';
}
sub _get_proxy_list {
	my $res = $scraper->scrape( URI->new($URL) );
	
	my @proxy_list =
		grep { /^[^:]+:[^:]+$/ }
		@$res;
	
	$fcache->set( $PROXY_KEY, \@proxy_list, $TTL );
	return( \@proxy_list );
}

sub set_black {
	my %args = @_;
	return() if (exists $black_list{$args{host_port}});
	
	my $black_stored = $fcache->get($BLACK_KEY) || {};
	$black_stored->{$args{host_port}} = time();
	$fcache->set( $BLACK_KEY, $black_stored );
	$black_list{$args{host_port}} = time();
	
	return( 1 );
}
