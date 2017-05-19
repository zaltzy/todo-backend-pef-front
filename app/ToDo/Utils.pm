package ToDo::Utils;
use strict;
use warnings;
use PEF::Front::Config;
use base 'Exporter';
our @EXPORT = qw(todo_with_url);

sub todo_with_url {
	$_[0]->{url} = cfg_main_url($_[0]->{id});
	$_[0];
}

1;
