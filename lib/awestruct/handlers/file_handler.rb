require 'awestruct/handlers/base_handler'

module Awestruct
  module Handlers
    class FileHandler < BaseHandler

      attr_accessor :path

      def initialize(site, path)
        super( site )
        @path = path
      end

      def stale?
        return true if ( @content.nil? || ( File.mtime( @path ) > @mtime ) )
        false
      end

      def raw_content
        read
        @content
      end

      def rendered_content(context)
        raw_content
      end

      private 

      def read
        ( @content = File.read( @path ) ) if stale?
        @mtime = File.mtime( @path )
        return @content
      end

    end
  end
end
