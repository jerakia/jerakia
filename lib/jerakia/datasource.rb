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
      attr_reader :response

      def initialize(lookup, opts)
        self.class.validate_options(opts)
        @response = Jerakia::Response.new(lookup)
        @options = opts
        @request = lookup.request 
        @features = []
      end

      def answer(data=nil)
        if block_given?
          while @response.want?
            yield @response
          end
        else
          @response.submit(data) if response.want? and not data.nil?
        end
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

          if block_given?
            unless opt.nil?
              raise Jerakia::DatasourceArgumentError, "Validation failed for #{name}" unless yield opt
            end
          end
          opt
        end
      end
      def self.validate_options(args)
        options.keys.each do |k|
          options[k].call(args[k])
        end

        args.keys.each do |k|
          raise Jerakia::DatasourceArgumentError, "Unknown option #{k}" unless options.keys.include?(k)
        end
      end
    end

    require 'jerakia/response'

#    @instances = {}
#
#    class << self
#      attr_reader :instances
#    end
#
#    def self.register(instance)
#      @instances[instance.name] = instance
#    end

    def self.load_datasource(name)
      require "jerakia/datasource/#{name.to_s}"
    end

    def self.class_of(name)
      return eval "Jerakia::Datasource::#{name.to_s.capitalize}"
    end
      

    def self.run(lookup)
      options  = lookup.datasource[:opts]
      datasource = class_of(lookup.datasource[:name]).new(lookup, options)
      datasource.lookup
      return datasource.response
    end

     





#    def initialize(name, _opts={})
#      puts "INIT"
#      @name = name
#      @options = {}
#      @features = []
#      @trigger = nil
#    
#      self.class.register(self)
##      @response = Jerakia::Response.new(lookup)
##      @options = opts
##      @lookup = lookup
##      @name = name
##      begin
##        require "jerakia/datasource/#{name}"
##        eval "extend Jerakia::Datasource::#{name.capitalize}"
##      rescue LoadError => e
##        raise Jerakia::Error, "Cannot load datasource #{name} in lookup #{lookup.name}, #{e.message}"
##      end
#    end

    ## used for verbose logging
#    def whoami
#      "datasource=#{@name}  lookup=#{@lookup.name}"
#    end

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
