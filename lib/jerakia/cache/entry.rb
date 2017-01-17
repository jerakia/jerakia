class Jerakia::Cache::Entry
  attr_accessor :key
  attr_accessor :content
  @@cache = Jerakia::Cache.new

  def initialize(key = '', _content = '')
    @@cache.add(key, self)
  end

  def valid?
    true
  end
end
