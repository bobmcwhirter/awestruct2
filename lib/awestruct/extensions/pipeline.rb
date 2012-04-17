
module Awestruct
  module Extensions
    class Pipeline

      def initialize(pipeline)
        @pipeline = pipeline
      end

      def extension(e)
        @pipeline.extension( e )
      end

      def helper(h)
        @pipeline.helper( h )
      end

      def transformer(t)
        @pipeline.transformer(t)
      end

    end
  end
end
