require 'awestruct/config'
require 'awestruct/site'
require 'awestruct/pipeline'
require 'awestruct/page'
require 'awestruct/page_loader'

require 'awestruct/extensions/pipeline'

require 'fileutils'

module Awestruct

  class Engine

    attr_reader :site
    attr_reader :pipeline

    def initialize(config=Awestruct::Config.new)
      @site = Site.new( self, config)
      @pipeline = Pipeline.new
      @site_page_loader = PageLoader.new( @site )
      @layout_page_loader = PageLoader.new( @site, :layouts )
    end

    def run(profile, base_url, default_base_url, force=false)
      load_pipeline
      load_pages
      execute_pipeline
      generate_output
    end

    def load_pipeline
      ext_dir = File.join( site.config.extension_dir )
      pipeline_file = File.join( ext_dir, 'pipeline.rb' )
      if ( File.exists?( pipeline_file ) )
        p = eval(File.read( pipeline_file ), nil, pipeline_file, 1)
        puts "p=#{p.inspect}"
        p.extensions.each do |e|
          pipeline.extension( e )
        end
        p.helpers.each do |e|
          pipeline.helper( e )
        end
        p.transformers.each do |e|
          pipeline.transformers( e )
        end
      end
    end

    def execute_pipeline
      pipeline.execute( site )
    end

    def load_pages
      @site_page_loader.load_all
      @layout_page_loader.load_all
      puts "pages #{@site.pages.inspect}"
    end

    def generate_output
      @site.pages.each do |page|
        puts "output_path #{page.output_path}"
        generated_path = File.join( site.config.output_dir, page.output_path )
        FileUtils.mkdir_p( File.dirname( generated_path ) )
        File.open( generated_path, 'w' ) do |file|
          file << page.rendered_content
        end
      end
    end

  end

end
