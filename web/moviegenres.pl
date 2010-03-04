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
my $movieartpath = '/home/boli/msl/movieart';
my $moviearturl = '/movieart';

my $dbh = opendb($dbname,$dbserver,$dbuser,$dbpass) || croak "Cannot open DBI connection";
my $query = new CGI;

if (exists $ENV{SERVER_NAME}) {
    print $query->header();
}

# Read and sanitise input

my $movieid = $query->param('movieid') || 0;
print <<EOL;
<html>
<head><title>bunchadb movie : genres</title></head>
<body bgcolor=black text=white>
<center>Genres</center>
<center>
<table>
EOL

my $sth = $dbh->prepare("SELECT DISTINCT genre FROM moviesgenres ORDER BY genre");
$sth->execute() or die "Unable to execute query: $dbh->errstr\n";
while (my @result = $sth->fetchrow_array){
	my ($genre) = @result;
	print "<tr><td><a href=\"/movies.pl?genre=$genre\">$genre</td></tr>";
}
$sth->finish;

print <<EOL;
</table>
</center>
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

sub MovieArtURL {
	my ($movieid,$type,$size) = @_;
	my $expectedfilename;
	my $sth = $dbh->prepare("SELECT artid,url FROM movieart WHERE (movieid=?) AND (type=?) AND (size=?);");
	$sth->execute($movieid,$type,$size);
	while (my @result = $sth->fetchrow_array ) {
		my ($artid, $url) = @result;
		my $file_ext;
		if ($url =~ /^.*(...)$/) {
			$file_ext = $1; # messy messy messy
		}
		$expectedfilename=$artid.".$file_ext";
		if (! -e $movieartpath."/".$expectedfilename) {
			$expectedfilename='unknown';
		}
	}
	return $expectedfilename;
}
