require 'awestruct/handlers/base_handler'

module Awestruct
  module Handlers
    class FileHandler < BaseHandler

      def initialize(site, delegate)
        super( site, delegate )
      end

      def raw_content
        ( @raw_content = delegate.raw_content ) unless @raw_content
        @raw_content
      end

      def rendered_content(context)
        raw_content
      end

    end
  end
end
