require 'awestruct/pipeline'
require 'awestruct/page'

module Awestruct

  class Engine

    attr_reader :pipeline

    def initialize()
      @pipeline = Pipeline.new
    end

    def create_context(site, page)
      context = OpenCascade.new( site.merge( page ) )
    end


    def load_pages(site)
    end

    def load_page(site, path)
      chain = pipeline.handler_chains[ path ]  
      return nil if chain.nil?
      handler = chain.create(site, path)
      Page.new( site, handler )
    end

  end

end
