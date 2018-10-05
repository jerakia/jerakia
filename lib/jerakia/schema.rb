class Jerakia::Schema

  class Key
    attr_reader :name
    attr_reader :namespace
    attr_reader :cascade
    attr_reader :merge
    attr_reader :alias
    attr_reader :to_key
    attr_reader :to_namespace

    def initialize(namespace,name,data)
      @name = name
      @namespace = namespace
      @cascade = true if data['cascade'] == true
      if data['merge']
        @merge = data['merge'].to_sym
      end
      if data['alias'].is_a?(Hash)
        @alias = true
        @to_key = data['alias']['key'] if data['alias']['key']
        @to_namespace = Array(data['alias']['namespace']) if data['alias']['namespace']
      end
    end

    def alias?
      @alias || false
    end

  end

  attr_reader :keys
  def initialize(namespace)

    @keys = {}

    opts = Jerakia.config[:schema] || {}

    schema_datasource = datasource(opts)
    schema_request = Jerakia::Request.new(
      :namespace  => namespace,
      :use_schema => false
    )

    Jerakia.log.debug("Schema lookup invoked for namespace: #{namespace}")

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
      raise Jerakia::SchemaError, "Schema lookup failed: #{e.message}"
    end

    schema_data = schema_lookup.payload || {}

    # Validate the returned data from the schema
    raise Jerakia::SchemaError, "Schema must return a hash" unless schema_data.is_a?(Hash)

    valid_opts = %w(alias cascade merge)
    schema_data.each do |keyname, schemaopts|
      schemaopts.keys.each do |key|
        unless valid_opts.include?(key)
          raise Jerakia::SchemaError, "Unknown schema option #{key} for key #{@name}"
        end
        @keys[keyname] ||= Jerakia::Schema::Key.new(namespace,keyname,schemaopts)
      end
    end

    Jerakia.log.debug("Schema returned #{schema_data}")

  end

  def has_key?(keyname)
    @keys.has_key?(keyname)
  end

  def key(keyname)
    @keys[keyname]
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
