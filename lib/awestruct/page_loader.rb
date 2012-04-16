
module Awestruct

  class PageLoader

    attr_reader :site
    attr_reader :root_dir

    def initialize(site, target)
      @site   = site 
      @target = target

      @root_dir = site.config.dir
      if ( @target == :layouts )
        @root_dir = Pathname.new( File.join( root_dir, '_layouts/' ) )
      end
    end

    def ignore?(path)
      site.config.ignore.include?( path ) 
    end

    def load_all
      root_dir.find do |path|
        if ( path == root_dir )
          next
        end
        basename = File.basename( path )
        if ( basename == '.htaccess' )
          #special case
        elsif ( basename =~ /^[_.]/ )
          Find.prune
          next
        end
        relative_path = path.relative_path_from( root_dir ).to_s
        if ignore?(relative_path)
          Find.prune
          next
        end
        page = load_page( path )
        if ( page )
          #inherit_front_matter( page )
          site.send( @target ) << page
        end
      end
    end

    def load_page(path)
      puts "load page #{path}"
      pathname = case( path )
        when Pathname:
          pathname = path
        else
          pathname = Pathname.new( path )
      end
      chain = site.engine.pipeline.handler_chains[ path ]
      return nil if chain.nil?
      handler = chain.create(site, Pathname.new(path))
      p = Page.new( site, handler )
      puts "loaded page #{p.class.inspect}"
      p 
    end

  end

end
