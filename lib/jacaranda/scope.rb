class Jacaranda::Scope

  attr_reader :value
  attr_reader :handler
  attr_reader :request

  def initialize(request,handler=nil)
    @value = {}
    @handler ||= request.scope || :metadata
    @request = request
    Jacaranda::Util.autoload('scope', @handler)
    instance_eval "extend Jacaranda::Scope::#{@handler.to_s.capitalize}"
    create
  end

end
