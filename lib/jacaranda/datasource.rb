require 'jacaranda/cache'
class Jacaranda::Datasource < Jacaranda::Cache

  require 'jacaranda/response'
  attr_reader :response
  attr_reader :options
  attr_reader :lookup

  def initialize(name, lookup, opts)
    @response = Jacaranda::Response.new(lookup)
    @options = opts
    @lookup = lookup
    @name = name
    require "jacaranda/datasource/#{name.to_s}"
    # rescue loaderrer
    eval "extend Jacaranda::Datasource::#{name.to_s.capitalize}"
  end


  ## used for verbose logging
  def whoami
    "#{@name} datasource in lookup #{@lookup.name}"
  end

  def option(opt, data={})
    @options[opt] ||= data[:default] || nil
    if @options[opt].nil?
      Jacaranda.crit "#{opt} must be configured in #{whoami}" if data[:mandatory]
    else 
      if data[:type]
        Jacaranda.crit "#{opt} must be a #{data[:type].to_s} in #{whoami}" unless @options[opt].is_a?(data[:type])
      end
    end
  end
    
          
end

