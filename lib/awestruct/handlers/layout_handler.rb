
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
        puts "BEGIN inheriting for #{page.inspect}"
        for_layout_chain(page) do |layout|
          puts "inheriting from #{layout.inspect}"
          page.inherit_front_matter_from( layout )
        end 
        puts "DONE inheriting for #{page.inspect}"
      end

      def for_layout_chain(page, &block)
        puts "CHAIN for #{page.inspect}"
        current_page = page 
        while ( ! current_page.layout.nil? )
          puts "look for layout #{current_page.layout.inspect}"
          puts site.layouts.inspect
          current_page = site.layouts[ current_page.layout ]
          puts "current= #{current_page.inspect}"
          if ( ! current_page.nil? )
            block.call( current_page )
          end
        end
      end

      def rendered_content(context)
        content = delegate.rendered_content( context )

        for_layout_chain(context.__effective_page || context.page) do |layout|
          context.content = content
          context.__effective_page = layout
          content = layout.rendered_content( context )
          puts "after loop #{content}"
        end

        content
      end

    end
  end
end
