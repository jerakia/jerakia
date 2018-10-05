policy :hiera do

  lookup :skip do
    datasource :dummy, { :return => 'foo'}
    confine request.key, 'never' # never use this lookup
  end

  lookup :default do
    datasource :file, {
      :format => :yaml,
      :docroot => "test/fixtures/var/lib/hiera",
      :searchpath => [
        "common"
      ],
    }
  end
end

