#!/usr/bin/perl

use lib qw'app ../app';

use ToDo::AppFrontConfig;
use PEF::Front::Preload qw(no_out_filters);
use PEF::Front::Route;
use DBIx::Struct (
	connector_module => 'PEF::Front::Connector',
	error_class      => 'DBIx::Struct::Error::Hash'
);

DBIx::Struct::connect();

PEF::Front::Route::add_route(
	sub {
		my $req = $_[0];
		$req->set_out_header('Access-Control-Allow-Origin'  => '*');
		$req->set_out_header('Access-Control-Allow-Headers' => 'accept, content-type');
		$req->set_out_header('Access-Control-Allow-Methods' => 'GET,HEAD,POST,DELETE,OPTIONS,PUT,PATCH');
		my $method = ucfirst lc $req->method;
		if ($req->path =~ m'^/(\d+)') {
			$req->param(id => $1);
		}
		if (defined($req->param('id')) && ($method eq 'Get' || $method eq 'Patch' || $method eq 'Put')) {
			my $item = DBC::Todo->findOneById($req->param('id'));
			if (!$item) {
				return [undef, 'L=404'];
			}
			$req->note(item => $item);
		}
		my $action = 'ajax';
		if (defined $req->param('id') || $method eq 'Post') {
			$action .= $method . 'Todo';
		} else {
			$action .= $method . 'AllTodos';
		}
		return [$action, 'L'];
	} => undef,
);

PEF::Front::Route->to_app();
