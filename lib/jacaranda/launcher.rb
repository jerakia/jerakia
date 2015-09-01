# Here we take a request object and read in the policy file
# which is evalulated in this instance
#
class Jacaranda::Launcher

  attr_reader :request
  attr_reader :answer
  def initialize(req)
    @@request = req
    invoke
  end

  def invoke
    policy_name=request.policy.to_s
    Jacaranda.log.info "Invoked lookup for #{@@request.key} using policy #{policy_name}"
    filename=File.join(Jacaranda.config.policydir, "#{policy_name}.rb")
    policydata=Jacaranda.filecache(filename)
    instance_eval policydata
  end

  def request
    @@request
  end


  def policy(name, opts={},  &block)
    policy = Jacaranda::Policy.new(name, opts, &block)
    policy.fire!
    @answer = policy.answer
  end
end



