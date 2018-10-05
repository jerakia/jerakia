# rubocop:disable Lint/Eval
#
require 'jerakia/cache'

class Jerakia
  class Datasource
    class Instance

      class << self
        attr_reader :features
        attr_accessor :options
      end

      attr_reader :options
      attr_reader :request
      attr_reader :dataset

      def initialize(dataset, lookup, opts)
        @dataset = dataset
        @options = self.class.set_options(opts)
        @request = lookup.request
        @features = []
      end

      def reply
        yield @dataset
      end

      def self.feature(name)
        @features << name.to_sym unless @features.include?(name.to_sym)
      end

      def features?(name)
        @features.include?(name)
      end

      def self.option(name, arguments = {}, &block)
        self.options={} if self.options.nil?
        @options[name] = Proc.new do |opt|
          if arguments[:default]
            opt = arguments[:default] if opt.nil?
          end
          if arguments[:required]
            raise Jerakia::DatasourceArgumentError, "Must specify #{name} parameter" if opt.nil?
          end

          if arguments[:type]
            unless opt.is_a?(arguments[:type]) || opt.nil?
              raise Jerakia::DatasourceArgumentError, "#{name} must be a #{arguments[:type].to_s}, got #{opt.class.to_s}"
            end
          end

          if block_given?
            unless opt.nil?
              raise Jerakia::DatasourceArgumentError, "Validation failed for #{name}" unless yield opt
            end
          end
          opt
        end
      end

      def self.set_options(args)
        opts = {}
        options.keys.each do |k|
          opts[k] = options[k].call(args[k])
        end
        validate_options(args)
        opts
      end

      def self.validate_options(args)
        args.keys.each do |k|
          raise Jerakia::DatasourceArgumentError, "Unknown option #{k}" unless options.keys.include?(k)
        end
      end
    end

    def self.load_datasource(name)
      require "jerakia/datasource/#{name.to_s}"
    end

    def self.class_of(name)
      return eval "Jerakia::Datasource::#{name.to_s.capitalize}"
    end


    def self.run(dataset, lookup)
      options  = lookup.datasource[:opts]
      datasource = class_of(lookup.datasource[:name]).new(dataset, lookup, options)
      datasource.lookup
      return datasource.dataset
    end
  end
end
