class Jerakia::Lookup::Plugin
  attr_reader :lookup

  def initialize(lookup)
    @lookup = lookup
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
