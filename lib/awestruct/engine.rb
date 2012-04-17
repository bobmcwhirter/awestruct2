require 'awestruct/config'
require 'awestruct/site'
require 'awestruct/pipeline'
require 'awestruct/page'
require 'awestruct/page_loader'

require 'awestruct/util/inflector'

require 'awestruct/extensions/pipeline'

require 'fileutils'

require 'hashery/open_cascade'

class OpenCascade

  def transform_entry(entry)
    case entry
    when Hash
      OpenCascade.new(entry) 
    when Array
      entry.map!{ |e| transform_entry(e) }
    else
      entry
    end
  end
end

module Awestruct

  class Engine

    attr_reader :site
    attr_reader :pipeline

    def initialize(config=Awestruct::Config.new)
      @site = Site.new( self, config)
      @pipeline = Pipeline.new
      @site_page_loader = PageLoader.new( @site )
      @layout_page_loader = PageLoader.new( @site, :layouts )
      adjust_load_path
    end

    def run(profile, base_url, default_base_url, force=false)
      load_pipeline
      load_pages
      execute_pipeline
      configure_compass
      set_urls( site.pages )
      generate_output
    end

    def adjust_load_path
      ext_dir = File.join( site.config.extension_dir )
      if ( $LOAD_PATH.index( ext_dir ).nil? )
        $LOAD_PATH << ext_dir
      end
    end

    def set_urls(pages)
      pages.each do |page|
        page_path = page.output_path
        if ( page_path =~ /^\// )
          page.url = page_path
        else
          page.url = "/#{page_path}"
        end
        if ( page.url =~ /^(.*\/)index.html$/ )
          page.url = $1
        end
      end
    end

    def load_pipeline
      ext_dir = File.join( site.config.extension_dir )
      pipeline_file = File.join( ext_dir, 'pipeline.rb' )
      if ( File.exists?( pipeline_file ) )
        p = eval(File.read( pipeline_file ), nil, pipeline_file, 1)
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

    def configure_compass
      Compass.configuration.project_type    = :standalone
      Compass.configuration.project_path    = site.config.dir
      Compass.configuration.sass_dir        = 'stylesheets'
      
      site.images_dir      = File.join( site.config.output_dir, 'images' )
      site.stylesheets_dir = File.join( site.config.output_dir, 'stylesheets' )
      site.javascripts_dir = File.join( site.config.output_dir, 'javascripts' )

      Compass.configuration.css_dir         = site.css_dir
      Compass.configuration.javascripts_dir = 'javascripts'
      Compass.configuration.images_dir      = 'images'
    end

    def load_pages
      @site_page_loader.load_all
      @layout_page_loader.load_all
    end

    def generate_output
      @site.pages.each do |page|
        generated_path = File.join( site.config.output_dir, page.output_path )
        FileUtils.mkdir_p( File.dirname( generated_path ) )
        File.open( generated_path, 'w' ) do |file|
          file << page.rendered_content
        end
      end
    end

    ####
    ##
    ## compat with awestruct 0.2.x
    ##
    ####

    def load_page(path)
      @site_page_loader.load_page( path )
    end

    def find_and_load_site_page(simple_path)
      path_glob = File.join( site.config.input_dir, simple_path + '.*' )
      candidates = Dir[ path_glob ]
      return nil if candidates.empty?
      throw Exception.new( "too many choices for #{simple_path}" ) if candidates.size != 1
      dir_pathname = Pathname.new( site.config.dir )
      path_name = Pathname.new( candidates[0] )
      relative_path = path_name.relative_path_from( dir_pathname ).to_s
      load_page( candidates[0] )
    end

  end

end
