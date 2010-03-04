#!/usr/bin/perl -w

use strict;
use Data::Dumper;
use CGI qw/:standard/;
use CGI::Carp 'fatalsToBrowser';
use DBI;

require "/home/boli/msl/dbsubfuncs.pl";

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
my $sth = $dbh->prepare("SELECT remoteid,releasedate,rating,datasource,overview,name,altname,imdb_id FROM movies WHERE movieid=?");
$sth->execute($movieid) or die "Unable to execute query: $dbh->errstr\n";
my @result = $sth->fetchrow_array;
my ($remoteid,$releasedate,$rating,$datasource,$overview,$name,$altname,$imdb_id) = @result;
my $art_cover =  $moviearturl."/".MovieArtFilename($movieid,'poster','cover');
my $art_backdrop =  $moviearturl."/".MovieArtFilename($movieid,'backdrop','original');
my $imdburl = "http://www.imdb.com/title/".$imdb_id;
#print "<tr><td><a href=\"$imdburl\"><img src=\"$artwork\" alt=\"$name\"></a></td><td><p>$overview</p></td></tr>\n"
$sth->finish;
print <<EOL;
<html>
<head><title>bunchadb movie : $name</title></head>
<body bgcolor=black text=white>
<table>
<tr><td align=center><img src="$art_cover"></td><td align=center><img width=80% src="$art_backdrop"></td></tr>
<tr><td></td><td><p><b>Alternative title : $altname</b></p>
<p><b>IMDB : </b><a href="$imdburl">$imdb_id</a></p>
<p><b>Released :</b>$releasedate</p>
<p><b>Overview :</b>$overview</p>
</td></tr>
EOL


print <<EOL;
</table>
</body>
</html>
EOL

exit 0;

####################################

sub MovieArtFilename {
	my ($movieid,$type,$size) = @_;
	my ($localname,$artid);
	my $sth = $dbh->prepare("SELECT artid,localname FROM movieart WHERE (movieid=?) AND (type=?) AND (size=?);");
	$sth->execute($movieid,$type,$size);
	my @result = $sth->fetchrow_array ;
		($artid,$localname) = @result;
		if ( (! -e $movieartpath."/".$localname) || ($localname eq '') ) {
			print "<!-- fetching $artid -->";
			$localname=fetchMovieArtbyArtID($artid);
		}
	return $localname;
}
