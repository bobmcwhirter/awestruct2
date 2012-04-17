
require 'hashery/open_cascade'
require 'ostruct'

module Awestruct

  class Page < OpenCascade

    attr_accessor :site
    attr_accessor :handler

    attr_reader :dependencies

    def initialize(site, handler)
      @site          = site
      @handler       = handler
      @dependencies  = []
    end

    def [](arg)
      if ( handler.front_matter.keys.include?( arg ) )
        r = handler.front_matter[ arg ]
      elsif ( handler.front_matter.keys.include?( arg.to_s ) )
        r = handler.front_matter[ arg.to_s ]
      else
        r = super(arg)
      end
      r
    end

    def create_context(content='')
      context = OpenStruct.new( :site=>site, :page=>self, :content=>content )
      context
    end

    def relative_source_path
      handler.relative_source_path
    end

    def simple_name
      handler.simple_name
    end

    def output_path
      @output_path || handler.output_path
    end

    def output_path=(path)
      case ( path )
        when Pathname:
          @output_path = path
        else
          @output_path = Pathname.new( path )
      end
    end

    def stale?
      handler.stale? || @dependencies.any?(&:stale?) 
    end

    def raw_content
      handler.raw_content
    end

    def rendered_content(context=nil)
      if ( context.nil? )
        context = create_context
      end
      handler.rendered_content( context )
    end

  end

end
