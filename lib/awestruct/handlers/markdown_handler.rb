
require 'awestruct/handlers/base_handler'
require 'rdiscount'

module Awestruct
  module Handlers
    class MarkdownHandler < BaseHandler

      def initialize(site, delegate)
        super( site, delegate )
      end

      def simple_name
        File.basename( relative_source_path, '.md' ) 
      end

      def output_filename
        File.basename( relative_source_path, '.md' ) + '.html'
      end

      def rendered_content(context)
        doc = RDiscount.new( raw_content )
        doc.to_html
      end

    end
  end
end
