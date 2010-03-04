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

my $seriesid = $query->param('series') || 0;
my $sth = $dbh->prepare("SELECT DISTINCT banner,SeriesName FROM series WHERE seriesid=?;");
$sth->execute($seriesid) or die "Unable to execute query: $dbh->errstr\n";
my ($seriesbanner,$seriesname) = $sth->fetchrow_array;
$sth->finish;

print <<EOL;
<html>
<head><title>bunchadb series</title></head>
<body>
<center><img src="$bannerpath/$seriesbanner"></center>
<table>
EOL
$sth = $dbh->prepare("SELECT season,episode,episodename,banner,overview FROM episodes WHERE seriesid=? ORDER BY season,episode;");
$sth->execute($seriesid) or die "Unable to execute query: $dbh->errstr\n";
while (my @result = $sth->fetchrow_array) {
	my ($season,$episode,$episodename,$epbanner,$overview) = @result;
	print "<tr><td><img width=400 src=\"$bannerpath/$epbanner\" alt=\"$seriesname S$season E$episode\"></a></td><td><p><b>S$season E$episode $episodename</b></p><p>$overview</p></td></tr>\n"
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

