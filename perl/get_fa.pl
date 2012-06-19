#!/usr/bin/env perl

use strict;
use Carp::Clan;

use Storable qw( nstore  retrieve dclone );
use Encode qw( encode  decode  encode_utf8  decode_utf8 );
use YAML;
use LWP;
use HTTP::Request::Common qw(POST  GET);
use Web::Scraper;
use Net::SMTP::TLS;
use List::AllUtils qw( shuffle part );
use File::Basename;
use Getopt::Long;
Getopt::Long::Configure("bundling");

use TT::PROXY;
use TT::MAIL2;
use TT::TIME qw(yyyy_mm_dd_hh_mm  ep_time);

my $exec_file = basename( $0 );
require "$ENV{HOME}/.pass/$exec_file.pass";

my $UA = 'Mozilla/5.0 (Linux; U; Android 2.3.5; ja-jp; F-05D Build/F0001) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1';
my %URL = (
	top => $_::TOP_URL,
);
my $ALRM_TIMEOUT = 20;

my $SAVE_FILE = "$ENV{HOME}/.fa.bin";
my $LOG_FILE  = "$ENV{HOME}/.fa.log";
my $PID_FILE  = "$ENV{HOME}/.fa.pid";

my $mail = TT::MAIL2->new(
#	from => $_::MAIL_FROM,
#	host => q{smtp.gmail.com},
#	port => 587,
#	user => $_::MAIL_USER,
#	pass => $_::MAIL_PASS,
#	to   => \@_::MAIL_TO,
	bcc  => \@_::MAIL_TO,
);
if (-e $PID_FILE) {
	print("ALREADY RUNNING\n");
	exit;
}
`touch $PID_FILE`;
$SIG{INT} = $SIG{TERM} = sub {_del_pid(); print("Catch SIGNAL\n");exit(1);};
$SIG{ALRM} = sub { die 'TIMEOUT!' };

my $PREFS         = decode_utf8(q{東京|埼玉|神奈川|海外});
my $PREF_FILTERS  = qr{$PREFS}o;
my $MAX_ERROR_CNT = 3;

my $scraper = scraper {
	process( 'form/table/table[ @width="100%" ]',
		'entries[]' => {
			entry => scraper {
				process(
					'div/table[ @width="100%" ]/td',
					header => 'TEXT',
				);
				process(
					'blockquote',
					body => 'TEXT',
				);
			},
		}
	);
};


GetOptions(
	'q'         => \my $query_send,
	's|start=i' => \my $start_yyyymmdd,
	'e|end=i'   => \my $end_yyyymmdd,
	'si=i'      => \my $start_id,
	'ei=i'      => \my $end_id,
	'p=i'       => \my $page_num,
) or _view_help(), exit( 1 );

if ($query_send) {
	_send_old_log(
		start    => $start_yyyymmdd,
		end      => $end_yyyymmdd,
		start_id => $start_id,
		end_id   => $end_id,
		page     => $page_num,
	);
	
	exit();
}

my ($proxy_host, $err_cnt);
while (1) {
	eval {
		my %parsed_result = ();
		map {
			my $page = $_;
			my $res = _get_contents($page);
			die 'Response : '.$res->status_line() if (! $res->is_success());
			my $parsed_result = _parse_res($res);
			%parsed_result = (
				%parsed_result, %$parsed_result,
			);
		}
		(1..1);

		my $diff_result   = _save_res(\%parsed_result);
		# 新規投稿有り！！
		if (ref $diff_result eq 'HASH' && %$diff_result) {
			$mail->send_mail(
				subject => decode_utf8('新着！').yyyy_mm_dd_hh_mm().'@fa',
				content => _make_content( $diff_result ),
			);
			$err_cnt = 0;
		}
		
		$mail->send_mail(
			subject => decode_utf8('エラー復帰 ').yyyy_mm_dd_hh_mm().' @fa',
			content => decode_utf8('捜索をつづけます。。。'),
		), $err_cnt = 0 if ($err_cnt > 0);
		sleep 60;
	};
	if (my $err = $@) {
		++$err_cnt;
		$mail->send_mail(
			subject => decode_utf8("エラー（$err_cnt 回） ").(yyyy_mm_dd_hh_mm()).' @fa',
			content => "$proxy_host\n $0 @ ".(`hostname`)." $err\n"
			           .($err_cnt == $MAX_ERROR_CNT ? 'die...' : ''),
		);
		TT::PROXY::set_black(
			host_port => $proxy_host,
		);

		_del_pid(), exit( 1 )
			if ($err_cnt == $MAX_ERROR_CNT);

		sleep 100;
	}
}


sub _make_content {
	my $result = shift;
	return() if (ref $result ne 'HASH' || ! %$result);

	my $content = "see $URL{top}\n";
	map {
		$content .=<<CONTENT;

$_->{id}: $_->{age}: $_->{nickname}
$_->{post_date}: $_->{pref}
$_->{body}

CONTENT
	}
	sort {$b->{id} <=> $a->{id}}
	values %$result;

	return( $content );
}
sub _save_res {
	my $new_result = shift;
	return() if (ref $new_result ne 'HASH' || !%$new_result);

	_log( 'NEW RESULT:', $new_result );

	my $old_result = -e $SAVE_FILE ? retrieve($SAVE_FILE)
	                               : {}
	                               ;
	_log( 'OLD RESULT:', $old_result );

	# 一週間前のデータは削除
	my $limit_time = time() - 7*24*3600;

	# ひとまず、差分をとる
	# oldに無くてnewにあるものが差分
	my %diff_result =
		map  { ($_->{id} => $_) }
		grep {
			$limit_time < _post_date_to_time( $_->{post_date} );
		}
		grep { $_->{pref} =~ $PREF_FILTERS      }
		grep { ! exists $old_result->{$_->{id}} }
		values %$new_result;

	_log( 'DIFF RESULT:', \%diff_result );

	if (%diff_result) {
		# oldすぎるものを削除しとく
		my %old_result = 
			map  { ($_->{id} => $_)                                  }
			grep { $limit_time < _post_date_to_time($_->{post_date}) }
			values %$old_result;

		# 付け合わせはidのみ
		# 古いものを新しい結果で上書きさせない
		my %merge_result = (
			%diff_result,
			%old_result,
		);

		nstore( \%merge_result, $SAVE_FILE );
	}

	return( dclone(\%diff_result) );
}

sub _parse_res {
	my $res = shift;

	my $content = decode( 'shiftjis', $res->content());
#	my $content = $res->content();
	my $scraped = $scraper->scrape( $content );
	return( {} )
		if (
			ref $scraped ne 'HASH'
			|| ref $scraped->{entries} ne 'ARRAY'
			|| !@{$scraped->{entries}});

	my %parsed_res =
		map  {
			my $r = $_;
			my ($header, $body) =
				map {$r->{entry}{$_}}
				qw( header  body );
			my ($id, $nickname, $age, $pref, $post_date) =
				$header =~ m{
					\[ (\d+) \]      # id
					.+? : ([^\s\(]+) # nickname
					[^/]+ /([^/]+)   # age
					/([^)]+)\)       # pref
					.+? : ([^\s]+)   # post_date
				}xo;
			! $id ? () :
			(int($id) => {
				id   => int($id), nickname  => $nickname,  age  => $age,
				pref => $pref,    post_date => $post_date, body => $body,
			});
		}
		grep {ref $_->{entry} eq 'HASH' && defined $_->{entry}{header}}
		@{$scraped->{entries}};

	return( \%parsed_res );
}

sub _get_contents {
	my $page = shift;

	my $ua = LWP::UserAgent->new();
	$ua->agent( $UA );
	$proxy_host = TT::PROXY::get_proxy();
	$ua->proxy( q{http}, "http://$proxy_host/" );
#	$ua->proxy( q{http}, 'socks://localhost:9050' );
#	$ua->proxy( q{http}, 'http://localhost:8118' );

	my %params = (
		m       => 'r_h',
		address => 0,
		sex     => 0,
		age     => 0,
		subject => 0,
		page    => $page,
	);
	my $req = POST( $URL{top}, [%params] );

	alarm $ALRM_TIMEOUT;
	my $res = eval {$ua->request( $req )};
	alarm 0;

	return( $res );
}

sub _send_old_log {
	my %args = @_;
	my $start = $args{start} ? ep_time($args{start}) : 0;
	my $end   = $args{end  } ? ep_time($args{end  }) : 0;
	my $s_id  = $args{start_id};
	my $e_id  = $args{end_id};

	my $old_log = -e $SAVE_FILE ? retrieve($SAVE_FILE) : die 'NO LOG!';
	die 'LOG is broken!' if (ref $old_log ne 'HASH' || ! %$old_log);
	my $page  = $args{page } || scalar keys %$old_log;


	my $i = 0;
	map  {
		$mail->send_mail(
			subject => decode_utf8('ログ送付').($_->[0]{post_date}).'@fa',
			content => _make_content( $_ ),
		);
	}
	part {int($i++ / $page)                                       }
	sort {$a->{id} <=> $b->{id}                                   }
	grep {!$e_id  || $e_id >= $_->{id}                            }
	grep {!$s_id  || $s_id <= $_->{id}                            }
	grep {!$end   || $end   >= _post_date_to_time($_->{post_date})}
	grep {!$start || $start <= _post_date_to_time($_->{post_date})}
	values %$old_log;

}

sub _post_date_to_time {
	my $post_date = shift;
	
	my ($yyyy, $mm, $dd) =
		$post_date =~ m{(\d\d\d\d)/(\d\d)/(\d\d)};

	return(
		Time::Local::timelocal(0,0,0, $dd, $mm-1, $yyyy)
	);
}

sub _log {
	my ($kind, $data) = @_;
	$data = {} if (ref $data ne 'HASH');

	my $i = 0;
	my $time = yyyy_mm_dd_hh_mm();

	my @data =
		grep {$i++ < 10            }
		sort {$b->{id} <=> $a->{id}}
		values %$data;
	my $ymd = `date +%Y%m%d`; chomp( $ymd );
	open(my $fh, '>>', "$LOG_FILE.$ymd");
	print( $fh "================ $kind ==================\n" );

	map {
		print( $fh
			join("\t",
				$time, @$_{qw(id  post_date)},
				encode_utf8($_->{pref})
			)."\n" );
	}
	@data;

	close( $fh );
}

sub _del_pid {
	unlink( $PID_FILE );
}

sub _view_help {
	print <<USAGE;
USAGE: $0 [-q] [-s start_yyyymmdd] [-e end_yyyymmdd] [-p p_num]
USAGE: $0 [-q] [-si start_id] [-e end_id] [-p p_num]

q: query mode (old log sending: no new data shouldn't be taken)
s: start yyyymmdd of old log
e: end_yyyymmdd of old log
p: item nums of one mail
si: start id of old log
ei: end id of old log

flag 's' and 'e' are also described 'start' and 'end'
USAGE

	exit();
}
