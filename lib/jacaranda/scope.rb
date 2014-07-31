class Jacaranda::Scope < Jacaranda::Policy

  attr_reader :value
  attr_reader :handler

  def initialize(handler=nil)
    @value = {}
    @handler ||= request.scope || :metadata
    Jacaranda::Util.autoload('scope', @handler)
    instance_eval "extend Jacaranda::Scope::#{@handler.to_s.capitalize}"
    create
  end

end
