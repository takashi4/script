#!/usr/bin/env perl

use strict;

use Storable qw( nstore  retrieve dclone );
use Encode qw( encode  decode  encode_utf8  decode_utf8 );
use utf8;
use YAML;
use LWP;
use HTTP::Request::Common qw(POST  GET);
use Web::Scraper;
use Net::SMTP::TLS;
use List::AllUtils qw( shuffle part );
use MIME::Base64;
use File::Basename;
use Getopt::Long;
Getopt::Long::Configure("bundling");

my $exec_file = basename( $0 );
require "$ENV{HOME}/.pass/$exec_file.pass";

my $UA = 'Mozilla/5.0 (Linux; U; Android 2.3.5; ja-jp; F-05D Build/F0001) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1';
my %URL = (
	top => $_::TOP_URL,
);
my $SAVE_FILE = "$ENV{HOME}/.fa.bin";
my $LOG_FILE  = "$ENV{HOME}/.fa.log";
my $MAIL_HOST = 'smtp.gmail.com';
my $MAIL_PORT = 587;
my @MAIL_TO   = @_::MAIL_TO;
my $MAIL_FROM = $_::MAIL_FROM;
my $PID_FILE  = "$ENV{HOME}/.fa.pid";

if (-e $PID_FILE) {
	print("ALREADY RUNNING\n");
	exit;
}
`touch $PID_FILE`;
$SIG{INT} = $SIG{TERM} = sub {_del_pid(); print("Catch SIGNAL\n");exit(1);};

my @PROXY_LIST = ();
chomp, push(@PROXY_LIST, $_) while (<DATA>);
my $PREF_FILTERS = qr{東京|埼玉|神奈川|海外}o;
my $MAX_ERROR_CNT = 3;


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
		my @parsed_result = ();
		map {
			my $page = $_;
			my $res           = _get_first_page($page);
			my $parsed_result = _parse_res($res);
			push( @parsed_result, @$parsed_result );
		}
		(1..2);

		my $diff_result   = _save_res(\@parsed_result);
		# 新規投稿有り！！
		if (ref $diff_result eq 'ARRAY' && @$diff_result) {
			_send_mail(
				subject => '新着！'._get_yyyymmdd().'@fa',
				content => _make_content( $diff_result ),
			);
			$err_cnt = 0;
		}
		
		_send_mail(
			subject => "エラー復帰 (".(_get_yyyymmdd()).') @fa',
			content => '捜索をつづけます。。。',
		), $err_cnt = 0 if ($err_cnt > 0);
		sleep 600;
	};
	if (my $err = $@) {
		++$err_cnt;
		_send_mail(
			subject => "エラー($err_cnt 回) (".(_get_yyyymmdd()).') @fa',
			content => "$proxy_host\n $0 @ ".(`hostname`)." $err\n"
			           .($err_cnt == $MAX_ERROR_CNT ? 'die...' : ''),
		);
		_del_pid(), exit( 1 )
			if ($err_cnt == $MAX_ERROR_CNT);
		sleep 60;
	}
}

sub _send_mail {
	my %args = @_;
	return() if (! $args{content});

	my $subject = encode_base64(encode_utf8($args{subject}), '');
#	my $header = encode('iso-2022-jp', decode_utf8(<<EOH));
#Content-type: text/plain; charset=ISO-2022-JP
	my $header = <<EOH;
FROM: $MAIL_FROM
Subject: =?utf-8?B?$subject?=
MIME-Version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: base64

EOH
#	my $msg = encode( 'iso-2022-jp', decode_utf8($args{content}) );
	my $msg = encode_base64(encode_utf8($args{content}));

	my $smtp = Net::SMTP::TLS->new(
		$MAIL_HOST,
		Port     => $MAIL_PORT,
		User     => $_::MAIL_USER,
		Password => $_::MAIL_PASS,
	);
	$smtp->mail($MAIL_FROM);
	$smtp->to(@MAIL_TO);
	$smtp->data();
	$smtp->datasend($header);
	$smtp->datasend($msg);
	$smtp->dataend();
	$smtp->quit();

	print "send finish!\n";
}

sub _make_content {
	my $result = shift;
	return() if (ref $result ne 'ARRAY' || !@$result);

	my $content = "see $URL{top}\n";
	map {
		$content .=<<CONTENT;

$_->{id}: $_->{age}: $_->{nickname}
$_->{post_date}: $_->{pref}
$_->{body}

CONTENT
	}
	@$result;

	return( $content );
}
sub _save_res {
	my $new_result = shift;
	return() if (ref $new_result ne 'ARRAY' || !@$new_result);

	_log( 'NEW RESULT:', $new_result );

	my $old_result = -e $SAVE_FILE ? retrieve($SAVE_FILE)
	                               : []
	                               ;
	_log( 'OLD RESULT:', $old_result );

	# 一週間前のデータは削除
	my $limit_time = time() - 7*24*3600;

	# ひとまず、差分をとる
	# oldに無くてnewにあるものが差分
	my %old = map {$_->{id} => 1} @$old_result;
	my @diff_result =
		sort {$b->{id} <=> $a->{id}}
		grep {
			$limit_time < _post_date_to_time( $_->{post_date} );
		}
		grep { $_->{pref} =~ $PREF_FILTERS }
		grep { !$old{$_->{id}}             }
		@$new_result;

	_log( 'DIFF RESULT:', \@diff_result );

	# 付け合わせはidのみ
	my %ids = ();
	my @merge_result =
		sort {$b->{id} <=> $a->{id}}
		grep {
			$limit_time < _post_date_to_time( $_->{post_date} );
		}
		grep { $_->{pref} =~ $PREF_FILTERS }
		grep { !$ids{$_->{id}}++           }
		@$new_result, @$old_result;

	nstore( \@merge_result, $SAVE_FILE ) if (@diff_result);
	return( dclone(\@diff_result) );
}

sub _get_time {
	my $yyyymmdd = shift;

	my ($yyyy, $mm, $dd) =
		$yyyymmdd =~ m{(\d\d\d\d)(\d\d)(\d\d)};
	return(
		Time::Local::timelocal(0,0,0, $dd, $mm-1, $yyyy)
	);
}

sub _get_yyyymmdd {
	my $time = shift || time();
	my @t = localtime( $time );
	
	return(
		sprintf('%04d/%02d/%02d %02d:%02d', $t[5]+1900, $t[4]+1, @t[3,2,1])
	);
}

sub _parse_res {
	my $res = shift;

	my $s = scraper {
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

	my $scraped = $s->scrape( $res );
	return( [] )
		if (
			ref $scraped ne 'HASH'
			|| ref $scraped->{entries} ne 'ARRAY'
			|| !@{$scraped->{entries}});

	my @parsed_res =
		map {
			my $r = $_;
			my ($header, $body) =
#				map {encode_utf8( decode('shiftjis', $r->{entry}{$_}) )}
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
			{
				id   => int($id), nickname  => $nickname,  age  => $age,
				pref => $pref,    post_date => $post_date, body => $body,
			};
		}
		grep {ref $_->{entry} eq 'HASH' && defined $_->{entry}{header}}
		@{$scraped->{entries}};

		return( \@parsed_res );
}

sub _get_first_page {
	my $page = shift;

	my $ua = LWP::UserAgent->new();
	$ua->agent( $UA );
#	my $proxy_host = (shuffle(@PROXY_LIST))[0];
	$proxy_host = (shuffle(@PROXY_LIST))[0];
	$ua->proxy( q{http}, $proxy_host );

	my %params = (
		m       => 'r_h',
#		address => encode('shiftjis', decode_utf8($pref)),
		address => 0,
		sex     => 0,
		age     => 0,
		subject => 0,
		page    => $page,
	);
	my $req = POST( $URL{top}, [%params] );
	my $res = $ua->request( $req );
#print $res->dump();
	return( $res );
}

sub _send_old_log {
	my %args = @_;
	my $start = $args{start} ? _get_time($args{start}) : 0;
	my $end   = $args{end  } ? _get_time($args{end  }) : 0;
	my $s_id  = $args{start_id};
	my $e_id  = $args{end_id};

	my $old_log = -e $SAVE_FILE ? retrieve($SAVE_FILE) : die 'NO LOG!';
	die 'LOG is broken!' if (ref $old_log ne 'ARRAY' || ! @$old_log);
	my $page  = $args{page } || scalar( @$old_log );


	my $i = 0;
	map  {
		_send_mail(
			subject => 'ログ送付'.($_->[0]{post_date}).'@fa',
			content => _make_content( $_ ),
		);
	}
	part {int($i++ / $page)                                       }
	sort {$a->{id} <=> $b->{id}                                   }
	grep {!$e_id  || $e_id >= $_->{id}                            }
	grep {!$s_id  || $s_id <= $_->{id}                            }
	grep {!$end   || $end   >= _post_date_to_time($_->{post_date})}
	grep {!$start || $start <= _post_date_to_time($_->{post_date})}
	@$old_log;

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
	my ($kind, $data) = @_;;

	my $i = 0;
	my $time = _get_yyyymmdd();

	my @data =
		grep {$i++ < 10             }
		sort {$b->{id} <=> $a->{id}}
		@$data;
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

# 使用不可串
#http://211-76-97-150.ebix.net.tw:80/
#http://113x43x162x61.ap113.ftth.ucom.ne.jp:81/
#http://fnttkyo003008.tkyo.fnt.ngn4.ppp.infoweb.ne.jp:8088/
#http://pull-phone.com:3128/
#http://v-182-163-72-148.ub-freebit.net:8080/
#http://133.43.100.193/
#http://118.1.75.217:3128/
#http://182.163.92.51:3128/
#http://122.249.105.133:8080/
#http://213.229.121.187:80/
#http://50-57-152-189.static.cloud-ips.com:80/
#http://asuka.tsreiz.jp:10080/
#http://h242-33.ntcu.net/
#http://ec2-176-34-58-27.ap-northeast-1.compute.amazonaws.com/
#http://122.252.183.60:8080/
#http://114.30.47.10/
#http://211-76-97-152.ebix.net.tw/
#http://211-76-97-148.ebix.net.tw/
#http://122.252.183.60:8080/

__DATA__
http://210.51.43.82/
http://c.oconee.k12.sc.us:553/
http://125.95.189.42:8909/

