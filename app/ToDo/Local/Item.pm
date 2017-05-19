package ToDo::Local::Item;
use DBIx::Struct qw(connector hash_ref_slice);

use strict;
use warnings;
use ToDo::Utils;

sub get {
	my ($req, $ctx) = @_;
	return {answer_data => todo_with_url($ctx->{item}->TO_JSON), result => "OK"};
}

# put & patch
sub update {
	my ($req, $ctx) = @_;
	for (qw|title completed order|) {
		$ctx->{item}->$_($req->{$_}) if defined $req->{$_};
	}
	return {answer_data => todo_with_url($ctx->{item}->TO_JSON), result => "OK"};
}

sub delete {
	my ($req, $ctx) = @_;
	DBC::Todo->delete({id => $req->{id}});
	return {answer_status => 204, result => "OK"};
}

sub create {
	my ($req, $ctx) = @_;
	my $item = new_row(
		'todo',
		title     => $req->{title},
		completed => 0,
		order     => $req->{order}
	);
	$item->fetch;
	return {answer_data => todo_with_url($item->TO_JSON), result => "OK"};
}

1;

