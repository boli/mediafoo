class Randombag
  def initialize(contents)
    @contents = contents
  end

  def select_one
    if @contents.empty?
      raise RuntimeError, "doh! out of stuff"
    end

    selection = @contents[rand(@contents.size)]
    @contents -= [ selection ]
    return selection
  end

  def add_one(item)
	  @contents += [ item ]
  end
end

class InfoFromMediaFilename
	attr_accessor :pathname, :filename, :basename, :year, :part, :season, :episode, :ext

	def initialize(pathname)
		@pathname = pathname
		filename = File.basename(pathname)
		@filename = filename
		if filename =~ /.*\((\d\d\d\d)\).*/
			@year = $1
		end
		if filename =~ /.*\[(\d\d\d\d)\].*$/
			@year = $1
		end
		if filename =~ /.+part *(\d+).*$/i
			@part = $1
		end
		if filename =~ /.+cd *(\d+).*$/i
			@part = $1
		end
		if filename =~ /.+ +([a-e])$/i
			@part = $1
		end
		@ext = filename[/(?:.*\.)(.*$)/,1]
		@basename = filename.sub (/\.(\w+)$/,'')
		@basename = @basename.sub(/ *\(\d\d\d\d\)/,'')
		@basename = @basename.sub(/ *\[\d\d\d\d\]/,'')
		@basename = @basename.sub(/ +[a-e]$/i,'')
		@basename = @basename.sub(/ *part *(\d+|[a-e]).*$/,'')
		@basename = @basename.sub(/ *cd *\d+.*$/i,'')
		@basename = @basename.sub(/\./,' ')
		if @basename =~ /(.*)[Ss](\d+)[Ee](\d+).*$/i
			@basename = $1
			@season = $2
			@episode = $3
		end
		if @basename =~ /(.*)(\d+)[Xx](\d+).*$/i
			@basename = $1
			@season = $2
			@episode = $3
		end
	end
end
