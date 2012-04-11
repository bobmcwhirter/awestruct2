
module Awestruct
  module Inputs
    class FileInput

      def initialize(site, path)
        @site = site
        @path = path
        @mtime = nil
      end

      def stale?
        return true if ( @content.nil? || ( File.mtime( @path ) > @mtime ) )
        false
      end

      def read
        ( @content = File.read( @path ) ) if stale?
        @mtime = File.mtime( @path )
        return @content
      end

      def raw_content
        read
      end

      def rendered_content(context)
        read
      end

    end
  end
end
