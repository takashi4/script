#!/usr/bin/env perl

use strict;
use utf8;
use LWP;
use HTTP::Request::Common qw(POST  GET);
use HTTP::Cookies;
use Web::Scraper;
use Encode qw( decode  encode  decode_utf8  encode_utf8 );
use Storable qw( nstore  retrieve );
#use Net::SMTP::TLS;
use List::Util qw( first );
use File::Basename;
use TT::MAIL2;

use YAML;

my $exec_file = basename( $0 );
require "$ENV{HOME}/.pass/$exec_file.pass";

my $cookie = HTTP::Cookies->new(
	file           => $_::COOKIE_FILE,
	autosave       => 1,
	ignore_discard => 1,
);
my $RESULT_FILE = "$ENV{HOME}/google_mes.dat";
#$ENV{HTTPS_PROXY} = $_::PROXY_URL;


my $mail = TT::MAIL2->new(
#	from => $_::MAIL{FROM},
#	host => $_::MAIL{HOST},
#	port => 587,
#	user => $_::MAIL{USER},
#	pass => $_::MAIL{PASS},
#	to   => $_::MAIL{TO},
	bcc  => $_::MAIL{BCC},
);

my $ua;
eval {
	while (1) {
		# 処理開始
		$ua = LWP::UserAgent->new();
		$ua->cookie_jar( $cookie );
		$ua->agent($_::UA);
		$ua->proxy([qw{http  https}], $_::PROXY_URL);

		_connect_google();
		my $res     = _get_mes_contents();
#print "\$res===========================\n";
#print $res->content();
#print Dump $res->content();
#print "\$res===========================\n";
		my $entries = _scrape_res( $res );
#print "\$entries===========================\n";
#print Dump $entries;
#print "\$entries===========================\n";
		
		if (ref $entries eq 'ARRAY' && @$entries) {
			my %new_data;
			map {
				my $entry = _scrape_entry();
				$new_data{$entry->{category}} = $entry;
			}
			@$entries;
#print "\%new_data: ========================\n";
#print Dump \%new_data;
#print "\%new_data: ========================\n";
			my $diff_data = _save_data( \%new_data );
#print "send_mail: ========================\n";
			_send_mail( $diff_data );
		}
		sleep( 1800 );
	}
};
if (my $err = $@) {
	$mail->send_mail(
		subject => $_::MAIL{ESUB},
		content => $err,
	);
	exit 1;
}

sub _send_mail {
	my $diff_data = shift;

	return() if (ref $diff_data ne 'HASH' || ! keys %$diff_data);

	$mail->send_mail(
		subject => $_::MAIL{SUBJ},
		content => join("\n",
			map {
				my $categ = $_;
				"$categ\n".join("\n",
					map  {<<CONTENT;}
  $_->{timestamp}
  $_->{title}
  $_->{url}
CONTENT
					sort { $b->{timestamp} <=> $a->{timestamp} }
					@{$diff_data->{$categ}{list}}
				)."\n"
			}
			keys %$diff_data
		),
	);
}

sub _save_data {
    my $data = shift;
    return() if (ref $data ne 'HASH' || ! keys %$data);

	my $old_data = -e $RESULT_FILE ? retrieve( $RESULT_FILE )
	                               : {}
	                               ;
	my %diff_data = ();
	map {
		my $categ = $_;
		if (! exists $old_data->{$categ}) {
			$diff_data{$categ} = $data->{$categ};
		}
		else {
			my @diff_data =
				grep {
					my $rHash = $_;
					ref $old_data->{$categ}{list} ne 'ARRAY'
					|| ! first {
						$_->{timestamp} eq $rHash->{timestamp}
						&& $_->{url} eq $rHash->{url}
					} @{$old_data->{$categ}{list}}
				}
				@{$data->{$categ}{list}};
			$diff_data{$categ}{list} = \@diff_data
                if (@diff_data);
		}
	}
	keys %$data;

	my %save_data = ( %$old_data, %$data, );
	nstore( \%save_data, $RESULT_FILE ) if (keys %diff_data);

	return( \%diff_data );
}

sub _scrape_entry {
	my $entry = shift || $_;
	
	my %ret = (
		category => $entry->{title},
	);
	my $req = GET( $entry->{url} );
	my $res = _wrapper_for_location( $req );
#print "============ \$res ===================\n";
#print Dump $ua;
#print Dump $res;	
	my $s = scraper {
		process( 'div.announcement',
			'announces[]' => {
				announce => scraper {
					process( 'h4 a', 
#						title => ['TEXT', sub { encode_utf8($_) }],
						title => 'TEXT',
						url   => '@href',
					);
					process( 'span.timestamp noscript',
						timestamp => 'TEXT',
					);
					process( '//span[ @class="timestamp" ]/span[ @dir="ltr" ]',
						timestamp => 'TEXT',
					);
				},
			},
		);
		
	};
	$ret{list} = [
		map  {$_->{announce}     }
		grep {$_->{announce}{url}}
		@{$s->scrape( $res )->{announces}}
	];
#print Dump $s->scrape( $res )->{announces};
	return( \%ret );
	

}

sub _scrape_res {
	my $res = shift;

	my $s = scraper {
		process( 'div.sites-embed',
			'entries[]' => {
				'entry' => scraper {
#					process( 'h4', title => ['TEXT', sub { $_ ? encode_utf8('■'.$_) : '' }] );
					process( 'h4', title => ['TEXT', sub { $_ ? "■$_" : '' }] );
					process( '//div[ @dir="ltr" ]/div/a', url => '@href' );
				},
			}
		);
	};
#print "====== \$row_entries ====\n";
#print Dump $s->scrape( $res )->{entries};
#print "====== \$row_entries ====\n";
	return([
		map  {$_->{entry}       }
		grep {$_->{entry}{title} && $_->{entry}{url}}
#		grep {$_->{entry}{title} }
		@{$s->scrape( $res )->{entries}}
	]);
}


sub _get_mes_contents {
	my $req = GET( $_::GOOGLE_URL{PORTAL} );
	my $res = $ua->request( $req );

	return( $res );
}

sub _connect_google {
	push(@{ $ua->{'requests_redirectable'} }, 'POST');

	my $req = POST(
		$_::GOOGLE_URL{INIT},
		HTTP_REFERER => $_::REFERER_URL,
		Content      => [%_::PASS_INFO],
	);
	my $res = $ua->request( $req );
#print "google connect Ph.1=============================\n";
#print Dump $res;
#print $res->content();
#print "google connect Ph.1=============================\n";
#die;
	my $content = $res->content();
	my ($url, %params) = _get_google_params( $content );
#print "google connect Ph.2=============================\n";
#print "url: $url\n";
#print "SAMLResponse: $params{SAMLResponse}\n";
#print "RelayState: $params{RelayState}\n";
#print "google connect Ph.2=============================\n";
	my $req2 = POST( $url, [%params] );
	my $res2 = $ua->request( $req2 );

#print "google connect Ph.3=============================\n";
#print "\$res2: ".Dump $res2;
#print "google connect Ph.3=============================\n";
	my $content2 = $res2->content();
	my ($url2, %params2) = _get_google_params( $content2 );
#print "google connect Ph.4=============================\n";
#print "url: $url2\n";
#print "SAMLResponse: $params2{SAMLResponse}\n";
#print "RelayState: $params2{RelayState}\n";
#print "google connect Ph.4=============================\n";
	my $req3 = POST( $url2, [%params2] );
	my $res3 = $ua->request( $req3 );

#print "google connect Ph.5=============================\n";
#print "\$res3: ".Dump $res3;
#print "google connect Ph.5=============================\n";
	my $content3 = $res3->content();
	my ($url3) =
		$content3 =~ m{
			<noscript> .* <a .* href="([^"]+)" .*
		}six;
	$url3 =~ s{&amp;}{&}g;
	my $req4 = GET( $url3 );
	my $res4 = $ua->request( $req4 );
}


sub _get_google_params {
	my $content = shift;
	
	my ($url, %params) =
		$content =~ m{
			<form  .* action="([^"]+)" .*
			<input .* name="(SAMLResponse)" .* value="([^"]+)" .*
			<input .* name="(RelayState)" .*   value="([^"]+)" .*
		}six;
	
	return(
		$url,
		%params,
	)
	
}

sub _wrapper_for_location {
	my $req = shift;
	
	my $res = $ua->request( $req );
	while (my $loc = $res->header('Location')) {
		$req = GET( $loc );
		$res = $ua->request( $req );
	}
	
	return( $res );
	
}
