require 'awestruct/config'
require 'awestruct/site'
require 'awestruct/pipeline'
require 'awestruct/page'
require 'awestruct/page_loader'

require 'awestruct/util/inflector'

require 'awestruct/extensions/pipeline'

require 'fileutils'

class OpenStruct
  def inspect
    "OpenStruct{...}"
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
      load_site_yaml(profile)
      load_yamls
      load_pipeline
      load_pages
      execute_pipeline
      configure_compass
      set_urls( site.pages )
      generate_output
    end

    def load_site_yaml(profile)
      site_yaml = File.join( site.config.config_dir, 'site.yml' )
      if ( File.exist?( site_yaml ) )
        data = YAML.load( File.read( site_yaml ) )
        site.interpolate = true
        profile_data = {}
        data.each do |k,v|
          if ( ( k == 'profiles' ) && ( ! profile.nil? ) )
            profile_data = ( v[profile] || {} )
          else
            site.send( "#{k}=", v )
          end
        end if data
        site.profile = profile

        profile_data.each do |k,v|
          site.send( "#{k}=", v )
        end
      end
    end

    def load_yamls
      Dir[ File.join( site.config.config_dir, '*.yml' ) ].each do |yaml_path|
        load_yaml( yaml_path ) unless ( File.basename( yaml_path ) == 'site.yml' )
      end
    end

    def load_yaml(yaml_path)
      data = YAML.load( File.read( yaml_path ) )
      name = File.basename( yaml_path, '.yml' )
      site.send( "#{name}=", massage_yaml( data ) )
    end

    def massage_yaml(obj)
      result = obj
      case ( obj )
        when Hash
          result = {}
          obj.each do |k,v|
            result[k] = massage_yaml(v)
          end
          #result = AStruct.new(result.inject({}) { |memo, (k, v)| memo[k.to_sym] = v; memo })
          result = AStruct.new( result )
        when Array
          result = []
          obj.each do |v|
            result << massage_yaml(v)
          end
      end
      result
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
        p.helpers.each do |h|
          pipeline.helper( h )
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
      @layout_page_loader.load_all( :post )
      @site_page_loader.load_all( :inline )
    end

    def generate_output
      @site.pages.each do |page|
        generated_path = File.join( site.config.output_dir, page.output_path )
        puts "generating #{generated_path}"
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

    def load_page(path, options={})
      page = @site_page_loader.load_page( path )
      if ( options[:relative_path] )
        fixed_relative_path = ( options[:relative_path].nil? ? nil : File.join( '', options[:relative_path] ) )
        page.relative_path = fixed_relative_path
      end
      page
    end

    def load_site_page(relative_path)
      load_page( File.join( site.config.dir, relative_path ) )
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
