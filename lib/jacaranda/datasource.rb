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
    require "jacaranda/datasource/#{name.to_s}"
    # rescue loaderrer
    eval "extend Jacaranda::Datasource::#{name.to_s.capitalize}"
  end


  def option(*o)
    @options[o[0]] ||= o[2]
    unless @options[o[0]].is_a?(o[1])
      Jacaranda.crit "#{o[0]} must be configured for lookup and be a #{o[1]}"
      exit
    end
  end
end

