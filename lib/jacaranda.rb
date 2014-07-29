class Jacaranda
  require 'jacaranda/policy'
  require 'jacaranda/lookup'
  require 'jacaranda/request'
  require 'jacaranda/log'
  require 'jacaranda/util'
  def initialize
  end

  def lookup (request)
    Jacaranda::Log.debug "Lookup Key #{request.key} using policy #{request.policy}"
    policy = Jacaranda::Policy.new(request)
    policy.load(:default)
    policy.fire!
    return policy.answer
  end

  def self.crit(msg)
    Jacaranda::Log.crit msg
    exit 1 
  end
end

