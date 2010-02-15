#!/usr/bin/env ruby

require 'text'
require('rubygems')
require('parseconfig')
require('tvdb_party')
require('pp')
require('open-uri')

class LookupTVDB
	
	attr_accessor :series, :episode, :found, :foundscore, :seriesname, :tvdbseriesid, :banner, :language, :zap2it_id, :imdb_id, :firstaired, :overview

	def initialize
		configfile = './msl.conf'
		config = ParseConfig.new(configfile)

		@bannerpath = config.params['tvdb']['bannerpath']
		tvdbapikey = config.params['tvdb']['apikey']

		@tvdb = TvdbParty::Search.new(tvdbapikey)
	end
	def lookupTVDB(element)
		@found = false
		bestmatch = 10000
		besthash = Hash.new
		results = @tvdb.search(element)
		results.each{ |result|
			thismatch=Text::Levenshtein.distance(element.upcase,result["SeriesName"].upcase)
			if thismatch < bestmatch
				bestmatch = thismatch
				besthash = result
			end
		}
		@seriesname = besthash["SeriesName"]
		@tvdbseriesid = besthash["seriesid"]
		@banner = besthash["banner"]
		@language = besthash["language"]
		@zap2it_id = besthash["zap2it_id"]
		@imdb_id = besthash["IMDB_ID"]
		@firstaired = besthash["FirstAired"]
		@overview = besthash["Overview"]
		@foundscore = bestmatch
		if bestmatch<10
			@found=true
		end
	end

	def by_TVDBid(tvdb_seriesid,major,minor)
		@series = @tvdb.get_series_by_id(tvdb_seriesid)
		@episode = @series.get_episode(major,minor)
	end

	def fetchbanner(bannername,nocache = false)
		bannerurl = "http://thetvdb.com/banners/"+bannername
		bannerfilename = @bannerpath+"/"+bannername
		if (not File.exist?(bannerfilename)) || nocache
			open("http://thetvdb.com/banners/"+bannername) do |i|
			File.open(bannerfilename, 'w') do |o|
				o.puts i.read
				end
			end
		end
	end

end
