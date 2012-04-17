require 'awestruct/config'
require 'awestruct/pipeline'
require 'awestruct/page'

module Awestruct

  class Engine

    attr_reader :pipeline

    def initialize(config=Awestruct::Config.new)
      @site = Site.new( self, config)
      @pipeline = Pipeline.new
      @site_page_loader = PageLoader.new( @site )
      @layout_page_loader = PageLoader.new( @site, :layouts )
    end

    def run(watch=false)
      load_pages
      generate_output
    end

    private

    def load_pages
      @site.pages   = @site_page_loader.load_all
      @site.layouts = @layout_page_loader.load_all
    end

  end

end
