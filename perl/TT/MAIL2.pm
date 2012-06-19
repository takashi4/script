# 自力メール送信Program
package TT::MAIL2;

use strict;
use warnings;
use utf8;

use Carp::Clan;
use YAML;

use MIME::Base64;
use Encode qw( encode  encode_utf8 );

#my $SENDMAIL = `which sendmail`;
#chomp( $SENDMAIL );
my $SENDMAIL = '/usr/sbin/sendmail';

sub new {
	my $klass = shift;
	my %args  = @_;

	$args{from} ||= 'n@reply.com';
	$args{name} ||= '名無しさん';


	# オプションパラメータ
	$args{no_print} or 1; # 標準出力にカキコしては駄目フラグ

	if (defined $args{to} && ref $args{to} ne 'ARRAY') {
		$args{to} = [$args{to}];
	}
	if (defined $args{bcc} && ref $args{bcc} ne 'ARRAY') {
		$args{bcc} = [$args{bcc}];
	}
	
	return( bless \%args, $klass );
}

sub send_mail {
	my $self = shift;
	my %args = @_;
	return() if (! $args{content});

	my $to = defined $args{to}   ? ref $args{to} eq 'ARRAY' ? join(',', @{$args{to}})
	                                                        : $args{to}
	       : defined $self->{to} ? join(',', @{$self->{to}})
	                             : ''
	                             ;
	my $bcc = defined $args{bcc}   ? ref $args{bcc} eq 'ARRAY' ? join(',', @{$args{bcc}})
	                                                           : $args{bcc}
	        : defined $self->{bcc} ? join(',', @{$self->{bcc}})
	                               : ''
	                               ;
	my $subject   = encode('MIME-Header', $args{subject});
	my $from_name = encode('MIME-Header', $self->{name});
	my $header = <<EOH;
From: $from_name <$self->{from}>
To: $to
Bcc: $bcc
Subject: $subject
MIME-Version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64

EOH
	my $msg = encode_base64(encode_utf8($args{content}));

	open( my $fh, '|-', $SENDMAIL, '-t' )
		or die "Can't exec $SENDMAIL";
	{
		print $fh $header;
		print $fh $msg;
	}
	close( $fh );

	print "send finish!\n" if (! $self->{no_print});
}

1;
