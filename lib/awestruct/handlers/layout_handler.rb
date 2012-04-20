
require 'awestruct/handlers/base_handler'

require 'haml'

module Awestruct
  module Handlers
    class LayoutHandler < BaseHandler

      def initialize(site, delegate)
        super( site, delegate )
      end

      def inherit_front_matter(page)
        delegate.inherit_front_matter( page )
        for_layout_chain(page) do |layout|
          page.inherit_front_matter_from( layout )
        end 
      end

      def for_layout_chain(page, &block)
        current_page = page 
        while ( ! ( current_page.nil? || current_page.layout.nil? ) )
          current_page = site.layouts.find_matching( current_page.layout, current_page.output_extension )
          if ( ! current_page.nil? )
            block.call( current_page )
          end
        end
      end

      def rendered_content(context, with_layouts=true)
        content = delegate.rendered_content( context )

        if ( with_layouts ) 
          for_layout_chain(context.__effective_page || context.page) do |layout|
            context.content = content
            context.__effective_page = layout
            content = layout.rendered_content( context, true )
          end
        end

        content
      end

    end
  end
end
