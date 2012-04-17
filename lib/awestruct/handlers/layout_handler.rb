
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

        while ( ! context.page.layout.nil? )
          layout_name = context.page.layout.to_s
          current_layout = site.layouts[ layout_name ]
          context.page.layout = nil
          if ( ! current_layout.nil? )
            context.page    = current_layout
            context.content = content
            content = current_layout.rendered_content( context )
            current_layout = site.layouts[ current_layout.layout ]
          end
        end

        content
      end

    end
  end
end
