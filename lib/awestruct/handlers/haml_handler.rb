
require 'awestruct/handlers/base_handler'

require 'haml'

module Awestruct
  module Handlers
    class HamlHandler < BaseHandler

      def initialize(site, delegate)
        super( site, delegate )
      end

      def rendered_content(context)
        rendered = ''
        options = (context.site.haml || {}).inject({}){|h,(k,v)| h[k.to_sym] = v; h } 
        options[:relative_source_path] = context.page.relative_source_path
        options[:site] = context.site
        haml_engine = Haml::Engine.new( delegate.raw_content, options )
        haml_engine.render( context )
      end

    end
  end
end
