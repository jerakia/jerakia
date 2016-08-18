class Jerakia
  module Dsl
    class Policy

      def self.evaluate_file(filename, request)
        policy = new(request)
        policy.evaluate_file(filename)
        policy.instance
      end

      def self.evaluate(request, &block)
        policy = new(request)
        policy.instance_eval &block
        policy.instance
      end

      attr_accessor :request
      attr_reader   :instance

      def initialize(req)
        @request=req
      end

      def evaluate_file(filename)
        policydata=Jerakia.filecache(filename)
        instance_eval policydata
      end

      def policy(name, opts={}, &block)
        @instance = Jerakia::Policy.new(name, opts, request)
        Jerakia::Dsl::Policyblock.evaluate(instance,&block)
      end
      
    end

    class Policyblock

      attr_accessor :policy

      def initialize(policy)
        @policy = policy
      end

      def self.evaluate(policy, &block)
        policyblock = new(policy)
        policyblock.instance_eval &block
      end

      def lookup(name, opts={}, &block)
        Jerakia::Dsl::Lookup.evaluate(name, policy, opts, &block)
      end
    end
  end

end
