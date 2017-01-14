class Jerakia::Lookup::Plugin
  attr_reader :lookup
  attr_reader :config

  def initialize(lookup, config)
    @lookup = lookup
    @config = config
  end

  def activate(name)
    instance_eval "extend Jerakia::Lookup::Plugin::#{name.to_s.capitalize}"
  end

  def scope
    lookup.scope
  end

  def request
    lookup.request
  end
end
