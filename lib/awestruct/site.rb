
require 'hashery/open_cascade'

module Awestruct

  class Site < OpenCascade

    attr_reader :dir
    attr_reader :output_dir
    attr_reader :tmp_dir

    attr_reader :layouts
    attr_reader :pages

    attr_reader :engine

    def initialize(engine)
      @engine = engine
      @pages = []
    end

    def create_context(page)
      engine.create_context( site, page )
    end

  end

end
