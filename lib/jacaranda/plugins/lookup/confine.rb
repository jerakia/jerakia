class Jacaranda::Lookup
  module Plugin

    def confine(key,match)
      invalidate unless scope[key] == match
    end

    def exclude(key,match)
      invalidate if scope[key] == match
    end
      
  end
end

