require 'awestruct/config'
require 'awestruct/site'
require 'awestruct/pipeline'
require 'awestruct/page'
require 'awestruct/page_loader'

module Awestruct

  class Engine

    attr_reader :pipeline

    def initialize(config=Awestruct::Config.new)
      @site = Site.new( self, config)
      @pipeline = Pipeline.new
      @site_page_loader = PageLoader.new( @site )
      @layout_page_loader = PageLoader.new( @site, :layouts )
    end

    def run(profile, base_url, default_base_url, force=false)
      load_pages
      #generate_output
    end

    private

    def load_pages
      @site.pages   = @site_page_loader.load_all
      @site.layouts = @layout_page_loader.load_all
    end

  end

end
