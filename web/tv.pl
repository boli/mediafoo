#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use CGI qw/:standard/;
use CGI::Carp 'fatalsToBrowser';

use DBI;
my $debug = 0;

my $dbserver = '127.0.0.1';
my $dbname = 'medialib';
my $dbuser = 'medialib';
my $dbpass = '';

my $bannerpath = '/banners';

my $dbh = opendb($dbname,$dbserver,$dbuser,$dbpass) || croak "Cannot open DBI connection";
my $query = new CGI;

if (exists $ENV{SERVER_NAME}) {
    print $query->header();
}

# Read and sanitise input

my $offset = $query->param('offset') || 0;
if ($offset < 0 ) { $offset = 0 };

print <<EOL;
<html>
<head><title>bunchadb</title></head>
<body>
<table>
EOL

my $sth = $dbh->prepare("SELECT DISTINCT seriesid,SeriesName,banner,IMDB_ID,Overview FROM series ORDER BY SeriesName;");
$sth->execute() or die "Unable to execute query: $dbh->errstr\n";
while (my @result = $sth->fetchrow_array) {
	my ($seriesid,$seriesname,$banner,$imdbid,$overview) = @result;
	print "<tr><td><a href=\"/series.pl?series=$seriesid\"><img width=400 src=\"$bannerpath/$banner\" alt=\"$seriesname\"></a></td><td><p>$overview</p></td></tr>\n"
}
$sth->finish;

print <<EOL;
</table>
EOL

print <<EOL;
</body>
</html>
EOL

exit 0;

####################################

sub opendb {

    my ($dbname, $dbhost, $dbuser, $dbpass) = @_;

    my $dsn = "DBI:mysql:database=$dbname;host=$dbhost";

    $debug && print STDERR "Database connect: database=$dbname host=$dbhost user=$dbuser pass=$dbpass\n";

    $dbh = DBI->connect($dsn,$dbuser,$dbpass) || croak "Cannot connect user '$dbuser' to database '$dbname' with DSN=$dsn";

    return $dbh;

}

