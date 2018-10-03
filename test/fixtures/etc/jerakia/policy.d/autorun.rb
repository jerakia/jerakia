policy :autorun do

  lookup :default, :use => :hiera do
    datasource :file, {
      :format => :yaml,
      :docroot => "test/fixtures/var/lib/hiera",
      :map_namespace => false,
      :searchpath => [
        "common"
      ],
    }
  end
end

