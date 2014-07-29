class Jacaranda::Lookup
  module Plugin

    def confine(key,match)
      invalidate unless request.metadata[key] == match
    end

    def exclude(key,match)
      invalidate if request.metadata[key] == match
    end
      
  end
end

