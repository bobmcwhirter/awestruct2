
module Awestruct

  class AStruct < Hash

    def initialize(hash=nil)
      hash.each{|k,v| self[k]=v } if hash
    end

    def cascade_for_nils!
      @cascade_for_nils = true 
      self
    end

    def key?(key)
      #puts "#{self.object_id} #{self.class}.key?( #{key.inspect } #{super(key.to_sym)})"
      super( key.to_sym )
    end

    def []=(key,value)
      #puts "#{self.object_id} #{self.class}.[]=( #{key.inspect} )"
      super( key.to_sym, value ) 
    end

    def [](key)
      #puts "#{self.object_id} #{self.class}.[]( #{key.inspect} )"
      transform_entry( super( key.to_sym ) )
    end

    def method_missing(sym, *args, &blk)
      #puts "#{self.object_id} #{self.class}.method_missing( #{sym.inspect} )"
      type = sym.to_s[-1,1]
      name = sym.to_s.gsub(/[=!?]$/, '').to_sym
      case type
      when '='
        self[name] = args.first
      when '!'
        __send__(name, *args, &blk)
      when '?'
        self[name]
      else
        if key?(name)
          self[name]
        elsif @cascade_for_nils
          self[name] = AStruct.new.cascade_for_nils! 
          self[name]
        else
          nil
        end
      end
    end

    alias_method :original_entries, :entries
    undef entries

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
