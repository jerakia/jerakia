require 'jerakia/dsl/policy'
require 'jerakia/dsl/lookup'

# Here we take a request object and read in the policy file
# which is evalulated in this instance
#
class Jerakia
  class Launcher
    attr_reader :request
    attr_reader :answer
    attr_reader :policies

    def initialize
      @policies = {}
      policy_files.each do |policy_file|
        policy = Jerakia::Dsl::Policy.evaluate_file(policy_file)
        raise Jerakia::PolicyError, "Policy #{policy.name} declared twice" if @policies[policy.name]
        @policies[policy.name] = policy
      end
    end

    def policy_dir
      Jerakia.config.policydir
    end

    def policy_files
      Dir[File.join(policy_dir, '*.rb')]
    end

    def self.evaluate(&block)
      Jerakia::Dsl::Policy.evaluate(&block)
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
