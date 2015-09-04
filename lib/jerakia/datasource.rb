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
    require "jerakia/datasource/#{name.to_s}"
    # rescue loaderrer
    eval "extend Jerakia::Datasource::#{name.to_s.capitalize}"
  end


  ## used for verbose logging
  def whoami
    "datasource=#{@name}  lookup=#{@lookup.name}"
  end

  def option(opt, data={})
    @options[opt] ||= data[:default] || nil
    Jerakia.log.debug("[#{whoami}]: options[#{opt}] to #{options[opt]} [#{options[opt].class}]")
    if @options[opt].nil?
      Jerakia.crit "#{opt} must be configured in #{whoami}" if data[:mandatory]
    else 
      if data[:type]
        Jerakia.crit "#{opt} must be a #{data[:type].to_s} in #{whoami}" unless @options[opt].is_a?(data[:type])
      end
    end
  end
    
          
end

