
module Awestruct

  class Layouts < Array

    def [](arg)
      case ( arg )
        when Fixnum
          super( arg )
        else
          find_by_simple_name( arg )
      end
    end


    def find_by_simple_name(arg)
      self.find{|e| e.simple_name == arg}
    end

     
  end

end
