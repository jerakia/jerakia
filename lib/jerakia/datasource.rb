# rubocop:disable Lint/Eval
#
require 'jerakia/cache'
class Jerakia
  class Datasource
    require 'jerakia/response'

    attr_reader :response
    attr_reader :options
    attr_reader :lookup

    def initialize(name, lookup, opts)
      @response = Jerakia::Response.new(lookup)
      @options = opts
      @lookup = lookup
      @name = name
      begin
        require "jerakia/datasource/#{name}"
        eval "extend Jerakia::Datasource::#{name.capitalize}"
      rescue LoadError => e
        raise Jerakia::Error, "Cannot load datasource #{name} in lookup #{lookup.name}, #{e.message}"
      end
    end

    ## used for verbose logging
    def whoami
      "datasource=#{@name}  lookup=#{@lookup.name}"
    end

    def option(opt, data = {})
      if @options[opt].nil? && data.key?(:default)
        @options[opt] = data[:default]
      end

      Jerakia.log.debug("[#{whoami}]: options[#{opt}] to #{options[opt]} [#{options[opt].class}]")
      if @options[opt].nil?
        raise Jerakia::PolicyError, "#{opt} option must be supplied for datasource #{@name} in lookup #{lookup.name}" if data[:mandatory]
      else
        if data[:type]
          if Array(data[:type]).select { |t| @options[opt].is_a?(t) }.empty?
            raise Jerakia::PolicyError,
                  "#{opt} is a #{@options[opt].class} but must be a #{data[:type]}  for datasource #{@name} in lookup #{lookup.name}"
          end
        end
      end
    end
  end
end
