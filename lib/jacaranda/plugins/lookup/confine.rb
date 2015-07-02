class Jacaranda::Lookup
  module Plugin

    def confine(key,match)
      invalidate unless scope[key][Regexp.new(match)] == key
    end

    def exclude(key,match)
      invalidate if scope[key][Regexp.new(match)] == key
    end
      
  end
end

