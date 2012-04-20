require 'guard/awestruct'

module Awestruct
  module CLI
    class Auto

      def initialize(path)
        @path = path
      end

      def run()
        Guard.setup
        Guard.start( :guardfile=>File.dirname(__FILE__) + '/Guardfile', 
                     :watchdir=>@path,
                     :watch_all_modifications=>true )
      end

    end
  end
end
