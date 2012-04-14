require 'awestruct/handler_chain'
require 'awestruct/handlers/file_handler'
require 'awestruct/handlers/interpolation_handler'
#require 'awestruct/handlers/markdown_handler'
require 'awestruct/handlers/haml_handler'

module Awestruct

  class HandlerChains


    DEFAULTS = [
      #HandlerChain.new( /\.md$/, 
        #Awestruct::Handlers::FileHandler,
        #Awestruct::Handlers::InterpolationHandler,
        #Awestruct::Handlers::MarkdownHandler
      #),
      HandlerChain.new( /\.haml$/, 
        Awestruct::Handlers::FileHandler,
        Awestruct::Handlers::HamlHandler
      ),
      HandlerChain.new( /.*/, Awestruct::Handlers::FileHandler )
    ]

    def initialize()
      @chains = []
    end

    def[](path)
      @chains.detect{|e| e.matches?( path ) }
    end

    def <<(chain)
      @chains += DEFAULTS and return if ( chain == :defaults )
      @chains << chain
    end

  end

end
