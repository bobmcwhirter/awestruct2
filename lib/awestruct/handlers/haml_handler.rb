
require 'awestruct/handlers/base_handler'

require 'haml'

module Awestruct
  module Handlers
    class HamlHandler < BaseHandler

      def initialize(site, delegate)
        super( site, delegate )
      end

      def simple_name
        File.basename( relative_source_path, '.html.haml' )
      end

      def output_filename
        File.basename( relative_source_path, '.haml' )
      end

      def rendered_content(context)
        puts "-a"
        rendered = ''
        options = context.site.haml? ? context.site.haml : {}
        puts "-b"
        options = options.inject({}){ |hash,(key,value)| 
          hash[key.to_sym] = value
          hash
        }
        puts "-c"
        options[:relative_source_path] = context.page.relative_source_path
        options[:site] = context.site
        puts "-d"
        haml_engine = Haml::Engine.new( delegate.raw_content, options )
        puts "-e"
        c = haml_engine.render( context )
        puts "-f"
        c
      end

    end
  end
end
