policy :hiera do

  lookup :default, :use => :hiera do
    datasource :file, {
      :format => :yaml,
      :docroot => "test/fixtures/var/lib/hiera",
      :searchpath => [
        "common"
      ],
    }
    plugin.hiera.rewrite_lookup
  end
end

