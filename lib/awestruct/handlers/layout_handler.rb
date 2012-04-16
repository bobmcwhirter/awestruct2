
require 'awestruct/handlers/base_handler'

require 'haml'

module Awestruct
  module Handlers
    class LayoutHandler < BaseHandler

      def initialize(site, delegate)
        super( site, delegate )
      end

      def rendered_content(context)
        content = delegate.rendered_content( context )
        puts "A: #{content}"

        if ( context.page.layout? )
          current_layout = site.layouts[ context.page.layout ]
          while ( ! current_layout.nil? )
            context.content = content
            content = current_layout.render( context )
            puts "B: #{content}"
            puts "cl.l #{current_layout.layout}"
            current_layout =  site.layouts[ current_layout.layout ]
          end
        end

        content
      end

    end
  end
end
