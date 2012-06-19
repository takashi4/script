package TT::PROXY2;

use strict;
use URI;
use YAML;

use LWP;
use HTTP::Request::Common qw(GET POST);
use Web::Scraper;
use Cache::FileCache;
use List::AllUtils qw( shuffle );

my $URL = q{http://www.freeproxylists.com};

my $UA  = 'Mozilla/5.0 (Linux; U; Android 2.3.5; ja-jp; F-05D Build/F0001) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1';
my $TTL = 30*60;

my $PROXY_KEY     = 'proxy';
my $BLACK_KEY     = 'black';
my $PROXY_TIMEOUT = 5;

my $fcache  = Cache::FileCache->new({
	namespace => __PACKAGE__,
});
my %black_list = %{$fcache->get( $BLACK_KEY ) || {}};

my @SCRAPERS = (
	scraper {
		process '/html/body/table/tr/td/table/tr/td/table/tr/td/a', 'urls[]' => '@href';
		result 'urls';
	},
	scraper {
		process '/html/body', onload => '@onload';
		result 'onload';
	},
	scraper {
		process '/html/root/quote', text => 'TEXT';
		result 'text';
	},
	scraper {
		process '//table/tr/td', 'text[]' => 'TEXT';
		result 'text';
	},
);

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

	die 'ALL BLACKS... or freeproxylists site error';
}
sub _get_proxy_list {
	my $uri = URI->new(qq{$URL/elite.html});

	my $url = shift @{$SCRAPERS[0]->scrape($uri) || []};
	return( [] ) if (! $url);

	my $onload = $SCRAPERS[1]->scrape($url);
	my $data_url = join('', $URL,
			$onload =~ m{'[^']+'[^,]*,[^']*'([^']+)'},
	);
	return( [] ) if (! $data_url);
	
	my $text = $SCRAPERS[2]->scrape( URI->new($data_url) );
	return( [] ) if (! $text);

	my @proxy_list = ();
	my $h = '';
	map  {$h ? do {push( @proxy_list, "$h:$_" ); $h = ''} : do {$h = $_}}
	grep { m{^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$|^\d{2,5}$}            }
	@{$SCRAPERS[3]->scrape($text) || []};

	$fcache->set( $PROXY_KEY, \@proxy_list, $TTL );
	return( \@proxy_list );
}

sub set_black {
	my %args = @_;
	return() if (exists $black_list{$args{host_port}});

#print "black: $args{host_port}\n";	
	my $black_stored = $fcache->get($BLACK_KEY) || {};
	$black_stored->{$args{host_port}} = time();
	$fcache->set( $BLACK_KEY, $black_stored );
	$black_list{$args{host_port}} = time();
	
	return( 1 );
}
