
require 'awestruct/context'

require 'hashery/open_cascade'
require 'ostruct'
require 'awestruct/astruct'

module Awestruct

  class Page < Awestruct::AStruct

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

    def key?(name)
      super(name) || handler.front_matter.key?(name) || handler.front_matter.key?( name.to_s ) 
    end

    def create_context(content='')
      context = Awestruct::Context.new( :site=>site, :page=>self, :content=>content )
      site.engine.pipeline.mixin_helpers( context )
      context
    end

    def relative_source_path
      handler.relative_source_path
    end

    def simple_name
      handler.simple_name
    end

    def output_path
      (@output_path || handler.output_path).to_s
    end

    def output_path=(path)
      case ( path )
        when Pathname:
          @output_path = path
        else
          @output_path = Pathname.new( path )
      end
    end

    def source_path
      handler.path
    end

    def stale?
      handler.stale? || @dependencies.any?(&:stale?) 
    end

    def content_syntax
      handler.content_syntax
    end

    def raw_content
      handler.raw_content
    end

    def rendered_content(context=create_context())
      handler.rendered_content( context )
    end

    def content
      rendered_content
    end


  end

end
