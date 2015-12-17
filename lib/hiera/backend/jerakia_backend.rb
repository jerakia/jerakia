class Hiera
  module Backend
    class Jerakia_backend

      def initialize(config = nil)
        require 'jerakia'
        @config = config || Hiera::Config[:jerakia] || {} 
        @policy = @config[:policy] || 'default'
        @jerakia = ::Jerakia.new(@config)
        Jerakia.log.debug("[hiera] hiera backend loaded with policy #{@policy}")
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

        Jerakia.log.debug("[hiera] backend invoked for key #{key} using namespace #{namespace}")

        metadata={}
        if scope.is_a?(Hash)
          metadata=scope
        else
          metadata = scope.real.to_hash
        end

        request = Jerakia::Request.new(
          :key         => key,
          :namespace   => namespace,
          :policy      => metadata["jerakia_policy"] || @policy,
          :lookup_type => lookup_type,
          :merge       => merge_type,
          :metadata    => metadata,
        )

        answer = @jerakia.lookup(request)
        answer.payload
      end
    end
  end
end
