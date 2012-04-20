
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
        return @delegate.stale? if @delegate
        false
      end

      def input_mtime(page)
        return @delegate.input_mtime(page) if @delegate
        0
      end

      def simple_name
        return @delegate.simple_name if @delegate
        nil
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

      def output_extension
        return @delegate.output_extension if @delegate
        File.extname( output_filename )
      end

      def path
        return @delegate.path if @delegate
        nil
      end

      def front_matter
        return @delegate.front_matter if @delegate
        {}
      end

      def content_syntax
        return @delegate.raw_content if @delegate
        :none
      end

      def raw_content
        return @delegate.raw_content if @delegate
        nil
      end

      def rendered_content(context, with_layouts=true)
        return @delegate.rendered_content(context, with_layouts) if @delegate
        nil
      end

      def content_line_offset
        return @delegate.content_line_offset if @delegate
        0
      end

      def inherit_front_matter(page)
        @delegate.inherit_front_matter(page) if @delegate
      end

      def to_chain
        chain = [ self ]
        chain += @delegate.to_chain if @delegate
        chain.flatten
      end

    end
  end
end
