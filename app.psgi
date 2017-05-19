#!/usr/bin/perl
use DBI;
my ($user, $password, $host, $port, $dbname) = $ENV{DATABASE_URL} =~ m{^postgres://([^:]+):([^:\@]+)\@([^:/]+):(\d+)/(.*)$};

my $dsn;
if (!$user) {
	$user     = ((getpwuid $>)[0]);
	$password = "";
	$dsn      = $user;
} else {
	$dsn = "dbi:Pg:dbname=$dbname;host=$host;port=$port";
}

my $dbh = DBI->connect($dsn, $user, $password) or die DBI->errstr();

$dbh->do(q{
	create table if not exists todo (
       id serial primary key,
       title text not null,
       completed boolean not null default false,
       "order" integer
	)
}) or die $dbh->errstr;
$dbh = undef;
$0 = "/app/bin/startup.pl";
do "/app/bin/startup.pl";