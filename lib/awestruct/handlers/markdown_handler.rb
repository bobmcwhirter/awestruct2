
require 'awestruct/handlers/base_handler'
require 'rdiscount'

module Awestruct
  module Handlers
    class MarkdownHandler < BaseHandler

      def initialize(site, delegate)
        super( site, delegate )
      end

      def rendered_content(context)
        doc = RDiscount.new( raw_page_content )
        doc.to_html
      end

    end
  end
end
