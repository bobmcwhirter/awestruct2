require 'guard/awestruct'

module Awestruct
  module CLI
    class Auto

      def run()
        Guard.setup
        Guard.start( :guardfile=>File.dirname(__FILE__) + '/Guardfile', :watch_all_modifications=>true )
      end

    end
  end
end
