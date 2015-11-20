policy :default do
  lookup :default do
    datasource :file, {
      :docroot => "test/fixtures/var/lib/jerakia",
      :format => :yaml,
      :searchpath => [
        "host/#{scope[:hostname]}",
        "env/#{scope[:env]}",
        "common",
    ],
    }
  end
end

