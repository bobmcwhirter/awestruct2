
module Awestruct

  class Layouts < Array

    def find_matching(simple_name, output_extension)
      puts "look for #{simple_name} #{output_extension}"
      self.find{|e| 
        ( e.simple_name == simple_name ) && ( e.output_extension == output_extension )
      }
    end

     
  end

end
