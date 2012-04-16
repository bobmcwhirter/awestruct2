require 'awestruct/pipeline'
require 'awestruct/page'

module Awestruct

  class Engine

    attr_reader :pipeline

    def initialize()
      @pipeline = Pipeline.new
    end

  end

end
