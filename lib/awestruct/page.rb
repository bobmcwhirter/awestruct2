
require 'hashery/open_cascade'

module Awestruct

  class Page < OpenCascade

    attr_accessor :site
    attr_accessor :handler

    attr_reader :dependencies

    def initialize(site, handler)
      @site         = site
      @handler      = handler
      @dependencies = []
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
