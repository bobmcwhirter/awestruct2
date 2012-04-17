require 'awestruct/cli/options'

module Awestruct
  module CLI
    class Invoker

      attr_reader :options

      def initialize(*options)
        options = options.flatten
        if ( ( ! options.empty? ) && ( options.first === Awestruct::CLI::Options ) )
          @options = options.first
        else
          @options = Awestruct::CLI::Options.parse! options
        end
        @threads = []
      end

      def invoke!
        invoke_init()     if ( options.init )
        invoke_script()   if ( options.script )
        invoke_force()    if ( options.force )
        invoke_generate() if ( options.generate )
        invoke_deploy()   if ( options.deploy )
        invoke_auto()     if ( options.auto )
        invoke_server()   if ( options.server )

        wait_for_completion()
      end

      def invoke_init()
      end

      def invoke_script()
      end

      def invoke_force()
      end

      def invoke_generate()
      end

      def invoke_deploy()
      end

      def invoke_auto()
      end

      def invoke_server()
      end


      private

      def run_in_thread(&block)
        @threads << Thread.new( &block )
      end

      def wait_for_completion()
        @threads.each do |thr|
          thr.join
        end
      end

    end
  end
end
