package ToDo::Local::Item;
use DBIx::Struct qw(connector hash_ref_slice);

use strict;
use warnings;

sub get {
	my ($req, $ctx) = @_;
	return {answer_data => $ctx->{item}->data, result => "OK"};
}

# put & patch
sub update {
	my ($req, $ctx) = @_;
	for (qw|title completed|) {
		$ctx->{item}->$_($req->{$_}) if defined $req->{$_};
	}
	return {answer_data => $ctx->{item}->data, result => "OK"};
}

sub delete {
	my ($req, $ctx) = @_;
	DBC::Todo->delete({id => $req->{id}});
	return {answer_status => 204, result => "OK"};
}

sub create {
	my ($req, $ctx) = @_;
	my $item = new_row('todo', title => $req->{title}, completed => 0);
	$item->fetch;
	return {answer_data => $item->data, result => "OK"};
}

1;
