
require 'open_cascade'

module Awestruct

  class Item < OpenCascade

    def initialize()
      @awestruct_inputs = []
    end

    def updated_at
      0
    end

    def stale?
      false
    end

    def raw_content
      nil
    end

    def content
      nil
    end

    def render
      nil
    end

  end

end
