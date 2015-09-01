class Hiera
  module Backend
    class Jacaranda_backend

      def initialize
        require 'jacaranda'
        @config = Config[:jacaranda] || {}
        @policy = @config[:policy] || 'default'
        @jacaranda = ::Jacaranda.new(Config[:jacaranda] || {}) 
        Jacaranda.log.debug("[hiera] hiera backend loaded with policy #{@policy}")

      end

        
      def lookup(key, scope, order_override, resolution_type)


        lookup_type = :first
        merge_type = :none
        
        case resolution_type
        when :array
          lookup_type = :cascade
          merge_type = :array
        when :hash
          lookup_type = :cascade
          merge_type = :hash
        end

        namespace = []

        if key.include?('::')
           lookup_key = key.split('::')
           namespace << lookup_key.shift
           key = lookup_key.join('::')
        end

        Jacaranda.log.debug("[hiera] backend invoked for key #{key} using namespace #{namespace}")
          
        metadata={}
        if scope.is_a?(Hash)
          metadata=scope
        else
          metadata = scope.real.to_hash
        end


        request = Jacaranda::Request.new(
          :key =>      key,
          :namespace   => namespace,
          :policy      => @policy,
          :lookup_type => lookup_type,
          :merge       => merge_type,
          :metadata    => metadata,
        )
 
        answer = @jacaranda.lookup(request)
        answer.payload
     

      end
    end
  end
end



