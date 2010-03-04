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
my $action = 'all';

my $genre = $query->param('genre'); 

if ($genre) { $action = 'bygenre' ; }

my $sth;

print <<EOL;
<html>
<head><title>bunchadb movies</title></head>
<body>
<table>
EOL
if ( $action eq 'all' ) {
	$sth = $dbh->prepare("SELECT movieid,rating,overview,name,imdb_id FROM movies ORDER BY name;");
	$sth->execute() or die "Unable to execute query: $dbh->errstr\n";
} elsif ( $action eq 'bygenre' ) {
	$sth = $dbh->prepare("SELECT movies.movieid,rating,overview,name,imdb_id FROM movies LEFT JOIN moviesgenres ON (moviesgenres.movieid=movies.movieid) WHERE (moviesgenres.genre=?) ORDER BY name;");
	$sth->execute($genre) or die "Unable to execute query: $dbh->errstr\n";
}
while (my @result = $sth->fetchrow_array) {
	my ($movieid,$rating,$overview,$name,$imdb_id) = @result;
	my $artwork =  $moviearturl."/".MovieArtFilename($movieid,'poster','thumb');
	my $movieurl = "/movie.pl?movieid=".$movieid;
	#print "<tr><td><a href=\"$imdburl\"><img src=\"$artwork\" alt=\"$name\"></a></td><td><p>$overview</p></td></tr>\n"
	print "<a href=\"$movieurl\"><img width=92 src=\"$artwork\" alt=\"$name\"></a>";
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

sub MovieArtFilename {
	my ($movieid,$type,$size) = @_;
	my $localname;
	my $sth = $dbh->prepare("SELECT localname FROM movieart WHERE (movieid=?) AND (type=?) AND (size=?);");
	$sth->execute($movieid,$type,$size);
	while (my @result = $sth->fetchrow_array ) {
		($localname) = @result;
		if (! -e $movieartpath."/".$localname) {
			$localname='unknown';
		}
	}
	return $localname;
}
