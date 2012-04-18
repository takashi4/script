package TT::MAIL;

use strict;
use Carp::Clan;
use YAML;

use Net::SMTP::TLS;
use MIME::Base64;
use Encode qw( encode  decode  encode_utf8  decode_utf8 );

sub new {
	my $klass = shift;
	my %args  = @_;

	# 必須パラメータ
	croak "invalid from: $args{from}"
		if (! _is_valid_addr($args{from}));
	$args{host} or croak "invalid host";
	$args{port} ||= 465; # ssmtp welknown port
	$args{user} or croak "invalid user";
	$args{pass} or croak "invalid pass";

	# 半必須パラメータ(new時点では不要でも実行時に必須)
	if (defined $args{to} && ref $args{to} ne 'ARRAY') {
		$args{to} = [$args{to}];
	}

	# オプションパラメータ
	$args{no_print} or 1; # 標準出力にカキコしては駄目フラグ

	return( bless \%args, $klass );
}

sub send_mail {
	my $self = shift;
	my %args = @_;
	return() if (! $args{content});

	my @to = defined $args{to} ? ref $args{to} eq 'ARRAY' ? @{$args{to}}
	                                                      : ($args{to})
	                           : @{$self->{to}}
	                           ;
	my $subject = encode_base64(encode_utf8($args{subject}), '');
	my $header = <<EOH;
FROM: $self->{from}
Subject: =?utf-8?B?$subject?=
MIME-Version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64

EOH
	my $msg = encode_base64(encode_utf8($args{content}));

	my $smtp = Net::SMTP::TLS->new(
		$self->{host},
		Port     => $self->{port},
		User     => $self->{user},
		Password => $self->{pass},
	);
	$smtp->mail($self->{from});
	$smtp->to(@to);
	$smtp->data();
	$smtp->datasend($header);
	$smtp->datasend($msg);
	$smtp->dataend();
	$smtp->quit();

	print "send finish!\n" if (! $self->{no_print});
}

sub _is_valid_addr {
	my $mail_address = shift;

	my ($acc, $dom) = split(/@/, $mail_address);

	return(
		length($acc) > 0 && length($dom) > 0 ? 1
		                                     : 0
	);
}
1;
