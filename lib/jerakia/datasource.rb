require 'jerakia/cache'
class Jerakia::Datasource 

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
      require "jerakia/datasource/#{name.to_s}"
      eval "extend Jerakia::Datasource::#{name.to_s.capitalize}"
    rescue LoadError => e
      raise Jerakia::Error, "Cannot load datasource #{name.to_s} in lookup #{lookup.name}, #{e.message}"
    end
  end


  ## used for verbose logging
  def whoami
    "datasource=#{@name}  lookup=#{@lookup.name}"
  end

  def option(opt, data={})
    @options[opt] ||= data[:default] || nil
    Jerakia.log.debug("[#{whoami}]: options[#{opt}] to #{options[opt]} [#{options[opt].class}]")
    if @options[opt].nil?
      raise Jerakia::PolicyError, "#{opt} option must be supplied for datasource #{@name} in lookup #{lookup.name}" if data[:mandatory]
    else 
      if data[:type]
        if Array(data[:type]).select { |t| @options[opt].is_a?(t) }.empty?
          raise Jerakia::PolicyError, 
            "#{opt} is a #{@options[opt].class} but must be a #{data[:type].to_s}  for datasource #{@name} in lookup #{lookup.name}"
        end
      end
    end
  end
    
          
end

