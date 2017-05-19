package ToDo::Local::List;
use DBIx::Struct qw(connector hash_ref_slice);

use strict;
use warnings;
use ToDo::Utils;

sub get {
	my ($req, $ctx) = @_;
	return {answer_data => all_rows('todo', sub {todo_with_url($_->TO_JSON)}), result => "OK"};
}

sub delete {
	my ($req, $ctx) = @_;
	DBC::Todo->delete();
	return {answer_status => 204, result => "OK"};
}

1;

