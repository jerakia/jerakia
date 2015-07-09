class Jacaranda::Lookup
  require 'jacaranda/datasource'
  require 'jacaranda/scope'
  require 'jacaranda/plugins/lookup/hiera_compat'
  require 'jacaranda/plugins/lookup/confine'

  attr_accessor :request
  attr_reader :datasource
  attr_reader :valid
  attr_reader :lookuptype
  attr_reader :scope_object
  attr_reader :output_filters
  attr_reader :name

  def initialize(name,req,scope,&block)
    
    @name=name
    @request=req
    @valid=true
    @scope_object=scope
    @output_filters=[]
    extend Jacaranda::Lookup::Plugin
    instance_eval &block
    
  end

  def datasource(source, opts={})
    @datasource = Jacaranda::Datasource.new(source, self, opts)
  end

  # If set, Jacaranda will pass each Jacaranda::Response object
  # to an output filter plugin
  #

  def scope
    @scope_object.value
  end


  def output_filter(name,opts={})
    @output_filters << { :name => name, :opts => opts }
  end
    

  def invalidate
    @valid=false
  end

  def valid?
    return @valid
  end

  def run
    @datasource.run
    response=@datasource.response
    @output_filters.each do |filter|
      response.filter! filter[:name], filter[:opts]
    end
    return response
  end


end

