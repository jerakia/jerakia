# rubocop:disable Lint/Eval
#
require 'jerakia/cache'
class Jerakia
  class Datasource

    require 'jerakia/response'

    @instances = {}

    class << self
      attr_reader :instances
    end

    attr_reader :options
    attr_reader :features
    attr_reader :trigger

    def self.register(instance)
      @instances[instance.name] = instance
    end

    def self.load_datasource(name)
      require "jerakia/datasource/#{name.to_s}"
    end

    def self.define(name, _opts={}, &block)
      instance = new(name, _opts)
      instance.instance_eval &block
    end

    def feature(name)
      @features << name.to_sym unless @features.include?(name.to_sym)
    end

    def action(&block)
      @trigger ||= Proc.new do |lookup, response, options|
        yield lookup, response, options
      end
    end

    def self.run(lookup)
      response = Jerakia::Response.new(lookup)
      options  = lookup.datasource[:opts]
      datasource = lookup.datasource[:name]
      instances[datasource].trigger.call lookup, response, options
      return response
    end

    def features?(name)
      @features.include?(name)
    end

    def option(name, arguments = {}, &block)
      @options[name] = Proc.new do |opt|
        if arguments[:default]
          opt = arguments[:default] if opt.nil?
        end
        if arguments[:required]
          raise Jerakia::DatasourceArgumentError, "Must specify #{opt} parameter" if opt.nil?
        end

        if block_given?
          unless opt.nil?
            raise Jerakia::DatasourceArgumentError, "Validation failed for #{opt}" unless yield opt
          end
        end
        opt
      end
    end




    attr_reader :response
    attr_reader :options
    attr_reader :name

    def initialize(name, _opts={})
      @name = name
      @options = {}
      @features = []
      @trigger = nil
    
      self.class.register(self)
#      @response = Jerakia::Response.new(lookup)
#      @options = opts
#      @lookup = lookup
#      @name = name
#      begin
#        require "jerakia/datasource/#{name}"
#        eval "extend Jerakia::Datasource::#{name.capitalize}"
#      rescue LoadError => e
#        raise Jerakia::Error, "Cannot load datasource #{name} in lookup #{lookup.name}, #{e.message}"
#      end
    end

    ## used for verbose logging
    def whoami
      "datasource=#{@name}  lookup=#{@lookup.name}"
    end

#    def option(opt, data = {})
#      if @options[opt].nil? && data.key?(:default)
#        @options[opt] = data[:default]
#      end
#
#      Jerakia.log.debug("[#{whoami}]: options[#{opt}] to #{options[opt]} [#{options[opt].class}]")
#      if @options[opt].nil?
#        raise Jerakia::PolicyError, "#{opt} option must be supplied for datasource #{@name} in lookup #{lookup.name}" if data[:mandatory]
#      else
#        if data[:type]
#          if Array(data[:type]).select { |t| @options[opt].is_a?(t) }.empty?
#            raise Jerakia::PolicyError,
#                  "#{opt} is a #{@options[opt].class} but must be a #{data[:type]}  for datasource #{@name} in lookup #{lookup.name}"
#          end
#        end
#      end
#    end
  end
end
