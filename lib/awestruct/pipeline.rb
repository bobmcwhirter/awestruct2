
require 'awestruct/handler_chains'

module Awestruct

  class Pipeline

    attr_reader :handler_chains

    def initialize()
      @handler_chains = HandlerChains.new
      @extensions     = []
      @helpers        = []
      @transformers   = []
    end

    def extension(e)
      @extensions << e
    end

    def helper(h)
      @helpers << h
    end

    def execute(site)
      @extensions.each do |e|
        e.execute(site)
      end
    end

  end

end
