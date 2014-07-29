class Jacaranda::Request

  attr_accessor :key
  attr_accessor :namespace
  attr_accessor :merge
  attr_accessor :policy
  attr_accessor :metadata
  attr_accessor :lookup_type
  attr_accessor :scope

  def initialize(opts={})
    @key = opts[:key] || ''
    @namespace =  opts[:namespace] || []
    @merge = opts[:merge] || false
    @policy = opts[:policy] || 'default'
    @metadata = opts[:metadata] || {}
    @lookup_type = opts[:lookup_type] || :first
    @scope = opts[:scope] || nil
  end

end
