policy :hiera do
  lookup :skip, :use => :hiera do
    datasource :dummy, :return => 'foo'
    confine request.key, 'never' # never use this lookup
  end

  lookup :default, :use => :hiera do
    datasource :file, :format => :yaml,
                      :docroot => 'test/fixtures/var/lib/hiera',
                      :searchpath => [
                        'common'
                      ]
    plugin.hiera.rewrite_lookup
  end
end

