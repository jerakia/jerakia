require 'jerakia'
require 'jerakia/log'
class Jerakia
  class Request
    attr_accessor :key
    attr_accessor :namespace
    attr_accessor :merge
    attr_accessor :policy
    attr_accessor :metadata
    attr_accessor :lookup_type
    attr_accessor :scope
    attr_accessor :scope_options
    attr_accessor :use_schema
    attr_reader   :schema

    def initialize(opts = {})
      options        = defaults.merge(opts)
      @key           = options[:key]
      @namespace     = options[:namespace]
      @merge         = options[:merge]
      @policy        = options[:policy]
      @metadata      = options[:metadata]
      @lookup_type   = options[:lookup_type]
      @scope         = options[:scope]
      @scope_options = options[:scope_options] || {}
      @use_schema    = options[:use_schema]

      Jerakia.log.debug("Request initialized with #{options}")

      if use_schema?
        load_schema
        reload_aliases unless key.nil?
      end
    end

    def load_schema
      @schema = Jerakia::Schema.new(namespace)
    end

    # Check if this request is aliased in the schema
    def reload_aliases
      if schema.has_key?(key)
        if schema.key(key).alias?
          newkey = schema.key(key).to_key
          newnamespace = schema.key(key).to_namespace

          # If we've changed namespaces we should reload the schema.
          if newnamespace
            if newnamespace != namespace
              @namespace = newnamespace
              load_schema
            end
          end
          
          @key = newkey if newkey
        end
      end
    end
    

    def use_schema?
      @use_schema
    end

    

    private

    def defaults
      {
        #key: nil,
        namespace: [],
        merge: false,
        policy: 'default',
        metadata: {},
        lookup_type: :first,
        scope: nil,
        use_schema: true
      }
    end
  end
end
