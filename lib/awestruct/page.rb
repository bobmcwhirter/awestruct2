
require 'hashery/open_cascade'

module Awestruct

  class Page < OpenCascade

    attr_accessor :site
    attr_accessor :input
    attr_accessor :handlers

    def initialize(site, input)
      @site = site
      @input = input
      @handlers = []
    end

    def rendered_content(context=nil)
      return @input.read if handlers.empty?

      ( context = site.create_context( self ) ) unless context
      delegate.rendered_content( context )
    end

  end

end
