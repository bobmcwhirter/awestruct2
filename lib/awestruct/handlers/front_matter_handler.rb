require 'awestruct/handlers/base_handler'

require 'yaml'

module Awestruct
  module Handlers
    class FrontMatterHandler < BaseHandler

      def initialize(site, delegate)
        super
        @parsed_parts = false
      end

      def front_matter
        parse_parts()
        @front_matter
      end

      def raw_content
        parse_parts()
        @raw_content
      end

      private

      def parse_parts
        return if @parsed_parts

        full_content = delegate.raw_content
        full_content.force_encoding(site.encoding) if site.encoding
        yaml_content = ''

        dash_lines = 0
        mode = :yaml

        @raw_content = ''

        full_content.each_line do |line|
          if ( line.strip == '---' )
            dash_lines = dash_lines +1
          end
          if ( mode == :yaml )
            yaml_content << line
          else
            @raw_content << line
          end
          if ( dash_lines == 2 )
            mode = :page
          end
        end
  
        if ( dash_lines == 0 )
          @raw_content = yaml_content
          yaml_content = ''
        elsif ( mode == :yaml )
          @raw_content = nil
        end

        @front_matter = YAML.load( yaml_content ) || {}
        @parsed_parts = true

      end

    end
  end
end
