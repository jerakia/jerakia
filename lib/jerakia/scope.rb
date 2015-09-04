class Jerakia::Scope < Jerakia::Policy

  attr_reader :value
  attr_reader :handler

  def initialize(handler=nil)
    @value = {}
    @handler ||= request.scope || :metadata
    Jerakia::Util.autoload('scope', @handler)
    instance_eval "extend Jerakia::Scope::#{@handler.to_s.capitalize}"
    create
  end

end
