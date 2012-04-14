
module Awestruct

  class HandlerChains

    def initialize()
      @chains = []
    end

    def[](path)
      @chains.detect{|e| e.matches?( path ) }
    end

    def <<(chain)
      @chains << chain
    end

  end

end
