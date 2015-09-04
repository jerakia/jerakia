class Jerakia::Lookup
  module Plugin

    def confine(key=nil,match)
      if key
        invalidate unless key[Regexp.new(match)] == key
      else
        invalidate
      end
    end

    def exclude(key=nil,match)
      if key
        invalidate if key[Regexp.new(match)] == key
      end
    end
      
  end
end

