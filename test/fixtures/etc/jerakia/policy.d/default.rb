policy :default do


  lookup :invalid do
    datasource :file, {
      :docroot    => "test/fixtures/var/lib/jerakia/data",
      :format     => :yaml,
      :searchpath => [
        "invalid",
    ],
    }
  end

  lookup :default do
    datasource :file, {
      :docroot    => "test/fixtures/var/lib/jerakia/data",
      :format     => :yaml,
      :searchpath => [
        "host/#{scope[:hostname]}",
        "env/#{scope[:env]}",
        "common",
    ],
    }

    exclude request.key, "skippy"
  end
end

