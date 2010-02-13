#!/usr/bin/env ruby

require('rubygems')
require('parseconfig')
require('dbi')
require('find')

argument = ARGV[0]
configfile = './msl.conf'

if not File.exist?(configfile)
      raise RuntimeError, "No config file"
end

config = ParseConfig.new(configfile)

dbserver = config.params['database']['server']
dbname   = config.params['database']['dbname']
dbuser   = config.params['database']['user']
dbpass   = config.params['database']['pass']

tvpaths = ['/mnt/storage3/video3', '/mnt/storage5/video5', '/mnt/storage6/video6', '/mnt/storage1/video7']
moviepaths = ['/mnt/storage1/video1', '/mnt/storage2/video2', '/mnt/storage4/video4']

begin
	dbh = DBI.connect("DBI:Mysql:#{dbname}:#{dbserver}", dbuser, dbpass)
	if argument == 'clean' 
		print "Cleaning episodes\n"
		sth = dbh.prepare("SELECT path FROM ep_files")
		sth.execute
		while row = sth.fetch do
			path = row[0]
			if not File.exist?(path)
				print "-"
				sth2 = dbh.prepare("DELETE FROM ep_files WHERE path=?")
				sth2.execute(path)
				sth2.finish
			end
		end
		sth.finish
		print "\nCleaning movies\n"
		sth = dbh.prepare("SELECT path FROM mov_files")
		sth.execute
		while row = sth.fetch do
			path = row[0]
			if not File.exist?(path)
				print "-"
				sth2 = dbh.prepare("DELETE FROM mov_files WHERE path=?")
				sth2.execute(path)
				sth2.finish
			end
		end
		sth.finish
	elsif argument == 'scan'
		tvpaths.each {|path|
			Find.find(path) do |entry|
				if File.file?(entry) and entry =~ /.+\.(avi|mpg|mkv|vob|divx|flv|mp4|mpeg|wmv|rmvb|rm)$/
					sth = dbh.prepare("SELECT * FROM ep_files WHERE path=?")
					sth.execute(entry)
					rows = sth.fetch_all.size
					sth.finish
					if rows==0
						sth = dbh.prepare("INSERT INTO ep_files(path,datasource) VALUES (?,'tvdb')")
						sth.execute(entry)
						sth.finish
						print "+"
					end
				end
			end
		}
	end
ensure
	dbh.disconnect if dbh
end
