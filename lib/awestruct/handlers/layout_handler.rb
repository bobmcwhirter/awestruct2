
require 'awestruct/handlers/base_handler'

require 'haml'

module Awestruct
  module Handlers
    class LayoutHandler < BaseHandler

      def initialize(site, delegate)
        super( site, delegate )
      end

      def rendered_content(context)
        layout_name = context.layout
        content = delegate.rendered_content( context )
        if ( ! layout_name.nil? )
          layout_page = context.site.layouts[ layout_name ]
          layout_context = layout_page.new_context( context )
          layout_context.content = content
          content = layout.rendered_content( layout_context ) 
        end
        content
      end

    end
  end
end
