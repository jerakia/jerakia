class Jerakia
  class Answer
    attr_reader :request
    attr_reader :dataset
    
    def initialize(request, dataset)
      @request = request
      @dataset = dataset
    end

    def found?
      return false if dataset.empty?
      if request.namespace
        return false if dataset.namespace(request.namespace).empty?
      end
     if request.key
        return false unless dataset.namespace(request.namespace).has_key?(request.key)
     end
     return true
    end

    def payload
      return nil unless found?
      # Key level request
      if request.key
        return dataset.namespace(request.namespace).key(request.key).value
      else
        return dataset.namespace(request.namespace).dump
      end
    end
  end
end
