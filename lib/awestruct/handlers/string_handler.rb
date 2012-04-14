require 'awestruct/handlers/base_handler'

module Awestruct
  module Handlers
    class StringHandler < BaseHandler

      def initialize(site, content)
        super( site )
        @content = content
      end

      def raw_content
        @content
      end

      def redered_content(context)
        raw_content
      end

    end
  end
end
