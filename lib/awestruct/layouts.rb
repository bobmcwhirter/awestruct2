
module Awestruct

  class Layouts < Array

    def [](arg)
      case ( arg )
        when Fixnum
          return super( arg )
        else
          return find_by_simple_name( arg )
      end
    end

    def find_by_simple_name(arg)
      self.find{|e| 
        puts "test #{arg} vs #{e.simple_name}"
        e.simple_name == arg
      }
    end

     
  end

end
