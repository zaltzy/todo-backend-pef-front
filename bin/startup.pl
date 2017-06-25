#!/usr/bin/perl

use lib qw'app ../app /app/app';

use ToDo::AppFrontConfig;
use PEF::Front::Preload qw(no_out_filters);
use PEF::Front::Route;
use DBIx::Struct (
	connector_module => 'PEF::Front::Connector',
	error_class      => 'DBIx::Struct::Error::Hash'
);

DBIx::Struct::connect();

# Custom routing scheme
# Prefix /ajax means "return JSON answer"
# To make `GET /` to call `GetAllTodos` this routing returns `/ajaxGetAllTodos`
# And so on:
# `DELETE /` -> `/ajaxDeleteAllTodos`
# exception rule: `POST /` -> `/ajaxPostTodo`
# `GET /$id` -> `/ajaxGetTodo`
# `PATCH /$id` -> `/ajaxPatchTodo`
# `PUT /$id` -> `/ajaxPatchTodo`
# `DELETE /$id` -> `/ajaxDeleteTodo`
# `OPTIONS *` -> `getOptionsAny`

# To see what API calls `GetAllTodos` and others do, look into model/ dir.

sub todo_routing {
	my $req = $_[0];
	# Add default CORS headers to answer
	$req->set_out_header('Access-Control-Allow-Origin'  => '*');
	$req->set_out_header('Access-Control-Allow-Headers' => 'accept, content-type');
	$req->set_out_header('Access-Control-Allow-Methods' => 'GET,HEAD,POST,DELETE,OPTIONS,PUT,PATCH');
	my $method = ucfirst lc $req->method;
	if($method eq 'Options') {
		return ['/getOptionsAny', 'L'];
	}
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
	my $action = '/ajax';
	if (defined $req->param('id') || $method eq 'Post') {
		$action .= $method . 'Todo';
	} else {
		$action .= $method . 'AllTodos';
	}
	return [$action, 'L'];
}

PEF::Front::Route::add_route(\&todo_routing => undef);

PEF::Front::Route->to_app();
