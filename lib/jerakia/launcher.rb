require 'jerakia/dsl/policy'
require 'jerakia/dsl/lookup'

# Here we take a request object and read in the policy file
# which is evalulated in this instance
#
class Jerakia
  class Launcher
    attr_reader :request
    attr_reader :answer

    def initialize(req)
      @request = req
    end

    def evaluate(&block)
      policy = Jerakia::Dsl::Policy.evaluate(request, &block)
      policy.execute
      @answer = policy.answer
    end

    def invoke_from_file
      policy_name = request.policy.to_s
      Jerakia.log.debug "Invoked lookup for #{request.key} using policy #{policy_name}"
      filename = File.join(Jerakia.config.policydir, "#{policy_name}.rb")
      policy = Jerakia::Dsl::Policy.evaluate_file(filename, request)
      policy.execute
      @answer = policy.answer
    end
  end
end
