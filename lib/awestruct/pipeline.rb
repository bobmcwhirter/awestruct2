
require 'awestruct/handler_chains'

module Awestruct

  class Pipeline

    attr_reader :handler_chains
    attr_reader :extensions
    attr_reader :transformers

    def initialize()
      @handler_chains = HandlerChains.new
      @extensions     = []
      @transformers   = []
    end

  end

end
