class Jerakia
  module Dsl
    class Lookup
      attr_reader :request
      attr_reader :scope_object
      attr_accessor :lookup

      def initialize(name, request, scope, opts = {})
        @request = request
        @scope_object = scope
        @lookup = Jerakia::Lookup.new(name, opts, request, scope)
      end

      def self.evaluate(name, request, scope, opts, &block)
        lookup_block = new(name, request, scope, opts)
        lookup_block.instance_eval &block
        return lookup_block.lookup
      end

      # define the data source for the lookup
      # @api: public
      def datasource(name, opts = {})
        lookup.datasource = { :name => name, :opts => opts }
      end

      # pass through exposed functions from the main lookup object
      # @api: public
      def confine(*args)
        lookup.confine(*args)
      end

      def scope
        @scope_object.value
      end

      def exclude(*args)
        lookup.exclude(*args)
      end

      def invalidate
        lookup.invalidate
      end

      def stop
        lookup.stop
      end

      def continue
        lookup.continue
      end

      def output_filter(*args)
        lookup.output_filter(*args)
      end

      def plugin
        lookup.plugin
      end
    end
  end
end
