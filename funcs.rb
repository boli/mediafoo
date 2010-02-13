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
	attr_accessor :filename, :basename, :year, :part, :ext

	def initialize(filename)
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
		#filename =~ s/\.(\w+)$//
		#@ext = $1
	end
end
