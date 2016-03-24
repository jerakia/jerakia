# Here we take a request object and read in the policy file
# which is evalulated in this instance
#
class Jerakia::Launcher

  attr_reader :request
  attr_reader :answer
  def initialize(req, &block)
    @request = req
    instance_eval &block
  end

  def invoke_from_file
    policy_name=request.policy.to_s
    Jerakia.log.debug "Invoked lookup for #{@request.key} using policy #{policy_name}"
    filename=File.join(Jerakia.config.policydir, "#{policy_name}.rb")
    begin
      policydata=Jerakia.filecache(filename)
    rescue Exception => e
      Jerakia.crit("Problem loading policy from #{filename}")
    end
    instance_eval policydata
  end

  def policy(name, opts={}, req=@request, &block)
    policy = Jerakia::Policy.new(name, opts, req, &block)
    policy.fire!
    @answer = policy.answer
  end
end



