
require 'hashery/open_cascade'

module Awestruct

  class Site < OpenCascade

    attr_reader :dir
    attr_reader :output_dir
    attr_reader :tmp_dir

    attr_reader :pages
    attr_reader :layouts

    attr_reader :config
    attr_reader :engine

    def initialize(engine, config)
      @engine = engine
      @pages = []
      @layouts = []
      @config = config
    end

    def dir
      @config.dir
    end

    def load_page(path)
      engine.load_path( self, path )
    end


  end

end
