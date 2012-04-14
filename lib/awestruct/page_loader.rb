
module Awestruct

  class PageLoader

    attr_reader :site
    attr_reader :config

    def initialize(site, config)
      @site   = site 
      @config = config
    end

    def load_all
      puts "loading all from #{site.config.dir}"
      site.config.dir.find do |path|
        puts "path #{path}"
        next if path == site.dir
        basename = File.basename( path )
        if ( basename == '.htaccess' )
          #special case
        elsif ( basename =~ /^[_.]/ )
          Find.prune
          next
        end
        relative_path = path.relative_path_from( site.dir ).to_s
        if config.ignore.include?(relative_path)
          Find.prune
          next
        end
        page = load_page( path )
        if ( page )
          #inherit_front_matter( page )
          site.pages << page
        end
      end
    end

    def load_page(path)
      pathname = case( path )
        when Pathname:
          pathname = path
        else
          pathname = Pathname.new( path )
      end
      chain = site.engine.pipeline.handler_chains[ path ]
      return nil if chain.nil?
      handler = chain.create(site, Pathname.new(path))
      Page.new( site, handler )
    end

  end

end
