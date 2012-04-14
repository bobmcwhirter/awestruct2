require 'awestruct/pipeline'
require 'awestruct/page'

module Awestruct

  class Engine

    attr_reader :pipeline

    def initialize()
      @pipeline = Pipeline.new
    end

    def create_context(site, page)
      context = OpenCascade.new( site.merge( page ) )
    end

  end

end
