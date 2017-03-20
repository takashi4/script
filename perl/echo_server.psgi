#!/usr/bin/env perl

use JSON;
use Plack::Request;
use YAML;

my $app = sub {
    my $req = Plack::Request->new(shift);
    

    my $res = $req->new_response(200);
    $res->content_type('application/json');
my $con = decode_json($req->content);
    $res->body(encode_json(+{
        method => $req->method,
        query_strings => $req->query_parameters->as_hashref,
		content => decode_json($req->content),
        body_parameters => $req->body_parameters->as_hashref,
        message => 'Hello JSON World!',
    }));
    return $res->finalize;
};

