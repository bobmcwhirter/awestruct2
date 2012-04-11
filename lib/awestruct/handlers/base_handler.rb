
require 'hashery/open_cascade'

module Awestruct
  module Handlers
    class BaseHandler

      attr_reader :site
      attr_reader :delegate

      def initialize(site, delegate)
        @site     = site
        @delegate = delegate
      end

      def front_matter
        return @delegate.front_matter if @delegate
        {}
      end

      def raw_content
        return @delegate.raw_content if @delegate
        nil
      end

      def rendered_content(context)
        return @delegate.rendered_content(context) if @delegate
        nil
      end

    end
  end
end
