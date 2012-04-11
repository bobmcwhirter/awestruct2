
module Awestruct
  module Inputs
    class StringInput

      def initialize(site, content)
        @site = site
        @content = content
      end

      def stale?
        false
      end

      def raw_content
        @content
      end

    end
  end
end
