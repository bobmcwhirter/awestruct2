
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
        rendered = ''
        #options = (context.site.haml || {}).inject({}){|h,(k,v)| puts "h=#{h}" ; h[k.to_sym] = v; h } 
        options = context.site.haml? ? context.site.haml : {}
        puts "options.class: #{options.class}"
        options = options.inject({}){ |hash,(key,value)| 
          puts "nil? #{hash.nil?}"
          hash[key.to_sym] = value
          hash
        }
        options[:relative_source_path] = context.page.relative_source_path
        options[:site] = context.site
        puts options.inspect
        haml_engine = Haml::Engine.new( delegate.raw_content, options )
        haml_engine.render( context )
      end

    end
  end
end
