
require 'awestruct/context'

require 'awestruct/handlers/no_op_handler'
require 'hashery/open_cascade'
require 'ostruct'
require 'awestruct/astruct'

module Awestruct

  class Page < Awestruct::AStruct

    attr_accessor :site
    attr_accessor :handler

    attr_reader :dependencies

    def initialize(site, handler=nil)
      @site          = site
      @handler       = handler || Awestruct::Handlers::NoOpHandler.new( site )
      @dependencies  = []
    end

    def prepare!
      handler.inherit_front_matter( self )
    end

    def inspect
      "Awestruct::Page{ #{self.object_id}: source_path=>#{source_path}, layout=>#{layout} }"
    end 

    def create_context(content='')
      context = Awestruct::Context.new( :site=>site, :page=>self, :content=>content )
      site.engine.pipeline.mixin_helpers( context )
      context
    end


    def inherit_front_matter_from(hash)
      puts "#{self.inspect} INHERIT #{hash.inspect}"
      hash.each do |k,v|
        unless ( key?( k ) )
          puts "  #{k}=#{v}"
          self[k.to_sym] = v
        else
          puts "  skip #{k}=#{v}"
        end
      end
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
