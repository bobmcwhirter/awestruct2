
require 'awestruct/handler_chains'

module Awestruct

  class Pipeline

    attr_reader :handler_chains

    def initialize()
      @handler_chains = HandlerChains.new
    end

  end

end
