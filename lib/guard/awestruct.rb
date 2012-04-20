require 'guard'
require 'guard/guard'

module Guard
  class Awestruct < Guard

    def initialize(watchers=[], options={})
      super
      puts "Guard::Awestrct init"
      puts watchers.inspect
      puts options.inspect
    end

    def start
      puts "Guard::Awestruct#start"
    end

    def stop
      puts "Guard::Awestruct#stop"
    end

    def reload
      puts "Guard::Awestruct#reload"
    end

    def run_all
      puts "Guard::Awestruct#run_all"
    end

    def run_on_change(paths)
      puts "Guard::Awestruct#run_on_change(#{paths.inspect})"
    end

    def run_on_deletion(paths)
      puts "Guard::Awestruct#run_on_deletion(#{paths.inspect})"
    end

  end
end
