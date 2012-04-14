
module Awestruct

  class Engine

    def create_context(site, page)
      context = OpenCascade.new( site.merge( page ) )
    end

  end

end
