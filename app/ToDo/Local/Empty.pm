package ToDo::Local::Empty;
use strict;
use warnings;

sub body {
	my ($req, $ctx) = @_;
	return {result => "OK"};
}

