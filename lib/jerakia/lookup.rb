class Jerakia::Lookup
  require 'jerakia/datasource'
  require 'jerakia/scope'
  require 'jerakia/plugins/lookup/hiera_compat'
  require 'jerakia/plugins/lookup/confine'

  attr_accessor :request
  attr_reader :datasource
  attr_reader :valid
  attr_reader :lookuptype
  attr_reader :scope_object
  attr_reader :output_filters
  attr_reader :name
  attr_reader :proceed

  def initialize(name,req,scope,&block)
    
    @name=name
    @request=req
    @valid=true
    @scope_object=scope
    @output_filters=[]
    @proceed=true
    extend Jerakia::Lookup::Plugin
    instance_eval &block
    
  end

  def datasource(source, opts={})
    @datasource = Jerakia::Datasource.new(source, self, opts)
  end

  # If set, Jerakia will pass each Jerakia::Response object
  # to an output filter plugin
  #

  def scope
    @scope_object.value
  end


  def output_filter(name,opts={})
    @output_filters << { :name => name, :opts => opts }
  end
    
  def proceed?
    @proceed
  end

  ## lookup function: stop
  # Enabling stop sets @proceed to false, which will cause Jerakia
  # *not* to load any more lookups in the policy if this lookup is
  # deemed as valid.  If the lookup is invalidated than Jerakia *will*
  # progress to the next lookup.   This is useful in conjuction with
  # the confine plugin where we want to segregate some lookups but
  # not worry about excluding from later lookups
  #
  def stop
    @proceed = false
  end

  ## lookup function: continue
  # Will cause Jerakia to continue to the next lookup in the policy
  # which is the default behaviour
  #
  def continue
    @proceed = true
  end

  ## lookup function: invalidate
  # Setting invalidate will mean this lookup will be skipped in the policy
  #
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

