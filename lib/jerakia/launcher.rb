# Here we take a request object and read in the policy file
# which is evalulated in this instance
#
class Jerakia::Launcher

  attr_reader :request
  attr_reader :answer
  def initialize(req)
    @@request = req
    invoke
  end

  def invoke
    policy_name=request.policy.to_s
    Jerakia.log.info "Invoked lookup for #{@@request.key} using policy #{policy_name}"
    filename=File.join(Jerakia.config.policydir, "#{policy_name}.rb")
    policydata=Jerakia.filecache(filename)
    instance_eval policydata
  end

  def request
    @@request
  end


  def policy(name, opts={},  &block)
    policy = Jerakia::Policy.new(name, opts, &block)
    policy.fire!
    @answer = policy.answer
  end
end



