require 'puppet'
require 'puppet/resource'

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

      def lookup(key, scope, _order_override, resolution_type)
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
          key = lookup_key.pop
          namespace = lookup_key
        end

        Jerakia.log.debug("[hiera] backend invoked for key #{key} using namespace #{namespace}")

        metadata = {}
        metadata = if scope.is_a?(Hash)
                     scope.reject { |_k, v| v.is_a?(Puppet::Resource) }
                   else
                     scope.real.to_hash.reject { |_k, v| v.is_a?(Puppet::Resource) }
                   end

        request = Jerakia::Request.new(
          :key         => key,
          :namespace   => namespace,
          :policy      => metadata['jerakia_policy'] || @policy,
          :lookup_type => lookup_type,
          :merge       => merge_type,
          :metadata    => metadata
        )

        answer = @jerakia.lookup(request)
        answer.payload
      end
    end
  end
end
