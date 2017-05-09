package ToDo::InFilter::Item;
use strict;
use warnings;

sub load {
	my ($id, $context) = @_;
	if ($context->{request}->note('item')) {
		$context->{item} = $context->{request}->note('item');
	}
	$id;
}

1;
