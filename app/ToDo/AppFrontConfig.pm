package ToDo::AppFrontConfig;

my ($user, $password, $host, $port, $dbname) = $ENV{DATABASE_URL} =~ m{^postgres://([^:]+):([^:\@]+)\@([^:/]+):(\d+)/(.*)$};

my $dsn;
if (!$user) {
	$user     = ((getpwuid $>)[0]);
	$password = "";
	$dsn      = $user;
} else {
	$dsn = "dbi:Pg:dbname=$dbname;host=$host;port=$port";
}
sub cfg_db_user              {$user}
sub cfg_db_password          {$password}
sub cfg_db_name              {$dsn}
sub cfg_no_multilang_support {1}
sub cfg_no_nls               {1}

1;
