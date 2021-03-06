#!/usr/bin/env perl

use strict;
use warnings;

use File::Basename qw(basename);
require "$ENV{HOME}/.pass/".basename(__FILE__).".pass";

use Plack::Request;
use Plack::Response;
use LWP::UserAgent;
use URI;
use Encode qw(encode  decode_utf8);
use TT::MAIL2;


my $mail = TT::MAIL2->new(
	to  => \@_::MAIL_TO,
);

my $app = sub {
	my $env = shift;

	my $req = Plack::Request->new($env);
	my $res = Plack::Response->new(200);
	$res->content_type('text/html');


	my $nickname = $req->query_parameters->{nickname};
	my $text     = $req->query_parameters->{text    };
	my $channel  = $req->query_parameters->{channel };

	if ($nickname && $text) {
		$mail->send_mail(
			subject => "IRC from $nickname$channel",
			content => decode_utf8($text),
		);
		$res->body("send mail !");
	}
	
	return( $res->finalize() );
};

