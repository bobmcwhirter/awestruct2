
require 'hashery/open_cascade'

module Awestruct
  module Handlers
    class BaseHandler

      attr_reader :site
      attr_reader :delegate

      def initialize(site, delegate=nil)
        @site     = site
        @delegate = delegate
      end

      def stale?
        false
      end

      def simple_name
        @delegate.simple_name
      end

      def relative_source_path 
        return @delegate.relative_source_path if @delegate
        nil
      end

      def output_filename
        return @delegate.output_filename if @delegate
        nil
      end

      def output_path
        File.join( File.dirname( relative_source_path ), output_filename )
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
