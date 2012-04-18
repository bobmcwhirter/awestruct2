
module Awestruct

  class AStruct < Hash

    def initialize(hash=nil)
      hash.each do |k,v|
        self[k]=v
      end
    end

    def key?(key)
      super( key.to_sym )
    end

    def []=(key,value)
      super( key.to_sym, value ) 
    end

    def [](key)
      transform_entry( super( key.to_sym ) )
    end

    def method_missing(sym, *args, &blk)
      type = sym.to_s[-1,1]
      name = sym.to_s.gsub(/[=!?]$/, '').to_sym
      case type
      when '='
        self[name] = args.first
      when '!'
        #@hash.__send__(name, *args, &blk)
        __send__(name, *args, &blk)
      when '?'
        self[name]
      else
        if key?(name)
          self[name] = transform_entry(self[name])
        else
          #self[name] = AStruct.new #self.class.new
          nil
        end
      end
    end

    def transform_entry(entry)
      case(entry)
        when AStruct
          entry
        when Hash
          AStruct.new( entry )
        when Array
          entry.map!{|i| transform_entry(i)}
        else
          entry
      end
    end

    def inspect
      "AStruct{...}"
    end
  
  end

end
