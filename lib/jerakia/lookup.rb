class Jerakia::Lookup
  require 'jerakia/datasource'
  require 'jerakia/scope'
  require 'jerakia/lookup/plugin'
  require 'jerakia/lookup/pluginfactory'
  require 'jerakia/lookup/plugin_config'

  attr_accessor :request
  attr_accessor :datasource
  attr_accessor :valid
  attr_accessor :proceed
  attr_reader :lookuptype
  attr_reader :scope_object
  attr_reader :output_filters
  attr_reader :name
  attr_reader :pluginfactory
  attr_reader :datasource

  def initialize(name, opts, req, scope)
    @name = name
    @request = req
    @valid = true
    @scope_object = scope
    @output_filters = []
    @proceed = true
    @pluginfactory = Jerakia::Lookup::PluginFactory.new

    # Validate options passed to the lookup
    #
    valid_opts = [:use]

    opts.keys.each do |opt_key|
      unless valid_opts.include?(opt_key)
        raise Jerakia::PolicyError, "Unknown option #{opt_key} for lookup #{name}"
      end
    end

    if opts[:use]
      Array(opts[:use]).flatten.each do |plugin|
        plugin_load(plugin)
      end
    end
  end

  # Retrieve plugin specific configuration from the global configuration file
  # gets passed to the plugin instance upon initilization.
  #
  def plugin_config(plugin)
    Jerakia::Lookup::PluginConfig.new(plugin)
  end

  def plugin_load(plugin)
    Jerakia.log.debug("Loading plugin #{plugin}")
    pluginfactory.register(plugin, Jerakia::Lookup::Plugin.new(self, plugin_config(plugin)))
  end

  def plugin
    pluginfactory
  end

  def get_datasource
    @datasource
  end

  def datasource(source, opts = {})
    @datasource = Jerakia::Datasource.new(source, self, opts)
  end

  # If set, Jerakia will pass each Jerakia::Response object
  # to an output filter plugin
  #

  def scope
    scope_object.value
  end

  def output_filter(name, opts = {})
    @output_filters << { :name => name, :opts => opts }
  end

  def proceed?
    proceed
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
    @valid = false
  end

  def valid?
    valid
  end

  def get_matches(key, match)
    matches = Array(match).select { |m| key[Regexp.new(m)] == key }
  end

  def confine(key = nil, match)
    if key
      invalidate if get_matches(key, match).empty?
    else
      invalidate
    end
  end

  def exclude(key = nil, match)
    if key
      invalidate unless get_matches(key, match).empty?
    end
  end

  def run
    Jerakia.log.verbose("lookup: #{@name} key: #{@request.key} namespace: #{@request.namespace.join('/')}")
    @datasource.run
    response = @datasource.response
    @output_filters.each do |filter|
      response.filter! filter[:name], filter[:opts]
    end
    response
  end

  private
end
