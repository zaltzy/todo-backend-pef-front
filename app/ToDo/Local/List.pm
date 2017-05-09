package ToDo::Local::List;
use DBIx::Struct qw(connector hash_ref_slice);

use strict;
use warnings;

sub get {
	my ($req, $ctx) = @_;
	return {answer_data => DBC::Todo->findAll, result => "OK"};
}

sub delete {
	my ($req, $ctx) = @_;
	DBC::Todo->delete();
	return {answer_status => 204, result => "OK"};
}

1;

