
require 'hashery/open_cascade'

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

    def relative_source_path
      handler.relative_source_path
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
      ( context = site.create_context( self ) ) unless context
      handler.rendered_content( context )
    end

  end

end
