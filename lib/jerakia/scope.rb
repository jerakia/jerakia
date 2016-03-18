class Jerakia::Scope

  attr_reader :value
  attr_reader :handler
  attr_reader :request

  def initialize(req)
    @value = {}
    @handler ||= req.scope || :metadata
    @request = req
    Jerakia::Util.autoload('scope', @handler)
    instance_eval "extend Jerakia::Scope::#{@handler.to_s.capitalize}"
    create
  end

end
