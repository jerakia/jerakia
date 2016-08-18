class Jerakia::Schema

  def initialize(request,opts)
    schema_datasource=datasource(opts)
    schema_request=Jerakia::Request.new(
      :metadata   => request.metadata,
      :key        => request.key,
      :namespace  => request.namespace,
      :use_schema => false,
    )

    schema_lookup = Jerakia::Launcher.new(schema_request) 
    schema_lookup.evaluate do
      policy :schema do
        lookup :schema do
          datasource *schema_datasource
        end
      end
    end

    @schema_data = schema_lookup.answer.payload || {}
    Jerakia.log.debug("Schema returned #{@schema_data}")

    if salias = @schema_data["alias"]
      Jerakia.log.debug("Schema alias found to #{@schema_data["alias"]}")
      request.namespace=Array(salias["namespace"]) if salias["namespace"]
      request.key = salias["key"] if salias["key"]
    end


    if @schema_data["cascade"]
      Jerakia.log.debug("Overriding lookup_type from #{request.lookup_type} to :cascade")
      request.lookup_type= :cascade
    end

    if ["array", "hash", "deep_hash"].include?(@schema_data["merge"])
      request.merge = @schema_data["merge"].to_sym
    end

  end

  def datasource(opts={})
    [ 
      :file, {
        :docroot        => opts["docroot"] || "/var/lib/jerakia/schema",
        :format         => opts["format"]  || :json,
        :enable_caching => opts["enable_caching"] || true,
        :searchpath     => [ '' ],
      }
    ] 
  end


end


