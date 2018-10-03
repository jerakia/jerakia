class Jerakia::Schema
  # Arguments: request(Jerakia::Request), opts(Hash)
  #
  attr_reader :merge
  attr_reader :cascade
  attr_reader :name
  attr_reader :namespace
  attr_reader :alias
  
  def initialize(request, opts={})
    @merge = nil
    @cascade = nil
    @name = request[:name]
    @namespace = request[:namespace]
    @alias = false
    schema_datasource = datasource(opts)
    schema_request = Jerakia::Request.new(
      :key        => @name,
      :namespace  => @namespace,
      :use_schema => false
    )

    Jerakia.log.debug("Schema lookup invoked for #{@name} namespace: #{@namespace}")

    begin
      schema_policy = Jerakia::Launcher.evaluate do
        policy :schema do
          lookup :schema do
            datasource *schema_datasource
          end
        end
      end
      schema_lookup = schema_policy.run(schema_request)
    rescue Jerakia::Error => e
      raise Jerakia::SchemaError, "Schema lookup for #{@name} failed: #{e.message}"
    end

    @schema_data = schema_lookup.payload || {}

    # Validate the returned data from the schema
    raise Jerakia::SchemaError, "Schema must return a hash for key #{@name}" unless @schema_data.is_a?(Hash)

    valid_opts = %w(alias cascade merge)
    @schema_data.keys.each do |key|
      unless valid_opts.include?(key)
        raise Jerakia::SchemaError, "Unknown schema option #{key} for key #{@name}"
      end
    end

    Jerakia.log.debug("Schema returned #{@schema_data}")

    if salias = @schema_data['alias']
      Jerakia.log.debug("Schema alias found to #{@schema_data['alias']}")
      @namespace = Array(salias['namespace']) if salias['namespace']
      @name = salias['key'] if salias['key']
     
    end

    if @schema_data['cascade']
      Jerakia.log.debug("Overriding lookup_type from to :cascade")
      @cascade = true
    end

    if @schema_data['merge']
      if %w(array hash deep_hash).include?(@schema_data['merge'])
        @merge = @schema_data['merge'].to_sym
      else
        raise Jerakia::SchemaError, "Invalid merge type #{@schema_data['merge']} found in schema for key #{@name}"
      end
    end
  end

  def datasource(opts = {})
    [
      :file, {
        :docroot        => opts['docroot'] || '/var/lib/jerakia/schema',
        :format         => opts['format']  || :json,
        :enable_caching => opts['enable_caching'] || true,
        :searchpath     => ['']
      }
    ]
  end
end
