require 'awestruct/handler_chain'
require 'awestruct/handlers/file_handler'
require 'awestruct/handlers/front_matter_handler'
require 'awestruct/handlers/interpolation_handler'
require 'awestruct/handlers/markdown_handler'
require 'awestruct/handlers/haml_handler'
require 'awestruct/handlers/layout_handler'

module Awestruct

  class HandlerChains


    DEFAULTS = [
      HandlerChain.new( /\.md$/, 
        Awestruct::Handlers::FileHandler,
        Awestruct::Handlers::FrontMatterHandler,
        Awestruct::Handlers::InterpolationHandler,
        Awestruct::Handlers::MarkdownHandler,
        Awestruct::Handlers::LayoutHandler
      ),
      HandlerChain.new( /\.haml$/, 
        Awestruct::Handlers::FileHandler,
        Awestruct::Handlers::FrontMatterHandler,
        Awestruct::Handlers::HamlHandler,
        Awestruct::Handlers::LayoutHandler
      ),
      HandlerChain.new( /.*/, Awestruct::Handlers::FileHandler )
    ]

    def initialize()
      @chains = []
    end

    def[](path)
      @chains.detect{|e| e.matches?( path.to_s ) }
    end

    def <<(chain)
      @chains += DEFAULTS and return if ( chain == :defaults )
      @chains << chain
    end

  end

end
