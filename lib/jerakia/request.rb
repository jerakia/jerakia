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

    def initialize(opts={})
      options        = defaults.merge(opts)
      @key           = options[:key]
      @namespace     = options[:namespace]
      @merge         = options[:merge]
      @policy        = options[:policy]
      @metadata      = options[:metadata]
      @lookup_type   = options[:lookup_type]
      @scope         = options[:scope]
      @scope_options = options[:scope_options] || {}

      Jerakia.log.debug("Request initialized with #{options}")
    end

    private

    def defaults
      {
        key: '',
        namespace: [],
        merge: false,
        policy: 'default',
        metadata: {},
        lookup_type: :first,
        scope: nil,
      }
    end
  end
end
