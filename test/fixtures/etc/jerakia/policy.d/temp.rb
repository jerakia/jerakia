policy :temp do

  lookup :schema do
    datasource :file, {
      :docroot => 'test/fixtures/var/lib/jerakia/schema',
      :format => :json,
      :enable_caching => true,
      :searchpath => ['']
    }
  end
end
