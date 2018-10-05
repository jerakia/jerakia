require 'jerakia/cache/file'

class Jerakia
  module Dsl
    class Policy
      def self.evaluate_file(filename)
        policy = new
        policy.evaluate_file(filename)
        policy.instance
      end

      def self.evaluate(&block)
        policy = new
        policy.instance_eval &block
        policy.instance
      end

      attr_accessor :request
      attr_reader   :instance

      def initialize()
      end

      def evaluate_file(filename)
        policydata = Jerakia::Cache::File.retrieve(filename)

        unless policydata
          raise Jerakia::PolicyError, "Could not load policy file, #{filename}"
        end

        instance_eval policydata
      end

      def policy(name, opts = {}, &block)
        @instance = Jerakia::Policy.new(name, opts)
        Jerakia::Dsl::Policyblock.evaluate(instance, &block)
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

      def lookup(name, opts = {}, &block)
        Jerakia.log.debug("Adding lookup #{name} for policy #{policy}")
        policy.lookups << Proc.new do |request, scope|
          Jerakia.log.debug("Invoking lookup #{name}")
          Jerakia::Dsl::Lookup.evaluate(name, request, scope, opts, &block)
        end
      end
    end
  end
end
