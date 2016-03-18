policy :default do
  lookup :default do
    puts "#{request.lookup_type} is my lookup type"
    datasource :file, {
      :docroot    => "test/fixtures/var/lib/jerakia/data",
      :format     => :yaml,
      :searchpath => [
        "host/#{scope[:hostname]}",
        "env/#{scope[:env]}",
        "common",
    ],
    }
  end
end

