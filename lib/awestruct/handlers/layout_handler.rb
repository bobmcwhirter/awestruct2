
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

        while ( ! context.page.layout.nil? )
          puts "page has layout!"
          layout_name = context.page.layout.to_s
          puts "looking for layout with simple name of #{layout_name.inspect}"
          current_layout = site.layouts[ layout_name ]
          puts "found layout #{current_layout.class}"
          context.page.layout = nil
          if ( ! current_layout.nil? )
            puts "** now layout #{layout_name} #{current_layout.class} #{current_layout.relative_source_path}"
            context.page    = current_layout
            context.content = content
            content = current_layout.rendered_content( context )
            puts "B: #{content}"
            puts "cl.l #{current_layout.layout}"
            current_layout = site.layouts[ current_layout.layout ]
          end
        end

        content
      end

    end
  end
end
