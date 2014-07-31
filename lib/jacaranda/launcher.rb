# Here we take a request object and read in the policy file
# which is evalulated in this instance
#
class Jacaranda::Launcher < Jacaranda

  attr_reader :request
  attr_reader :answer
  def initialize(req)
    @@request = req
    invoke
  end

  def invoke
    policy_name=request.policy.to_s
    filename=File.join(config.policydir, "#{policy_name}.rb")
    policydata=File.read(filename)
    instance_eval policydata
  end

  def request
    @@request
  end


  def policy(name, &block)
    Jacaranda::Log.debug "Lookup Key #{request.key} using policy #{request.policy}"
    policy = Jacaranda::Policy.new(&block)
    policy.fire!
    @answer = policy.answer
  end
end



