class Jerakia::Lookup
  require 'jerakia/datasource'
  require 'jerakia/scope'
  require 'jerakia/lookup/plugin'
  require 'jerakia/lookup/pluginfactory'

  attr_accessor :request
  attr_reader :datasource
  attr_reader :valid
  attr_reader :lookuptype
  attr_reader :scope_object
  attr_reader :output_filters
  attr_reader :name
  attr_reader :proceed
  attr_reader :pluginfactory

  def initialize(name,opts,req,scope,&block)
    
    @name=name
    @request=req
    @valid=true
    @scope_object=scope
    @output_filters=[]
    @proceed=true
    @pluginfactory = Jerakia::Lookup::PluginFactory.new

    if opts[:use]
       Array(opts[:use]).flatten.each do |plugin|
        plugin_load(plugin)
      end
    end

    instance_eval &block
    
  end
 
  def plugin_load(plugin)
    Jerakia.log.debug("Loading plugin #{plugin}")
    @pluginfactory.register(plugin, Jerakia::Lookup::Plugin.new(self))
  end

  def plugin
    @pluginfactory
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


  def get_matches(key,match)
    matches = Array(match).select { |m| key[Regexp.new(m)] == key}
  end
  
  def confine(key=nil,match)
    if key
      invalidate unless get_matches(key,match).size > 0
    else
      invalidate
    end
  end

  def exclude(key=nil,match)
    if key
      invalidate if get_matches(key,match).size > 0
    end
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

