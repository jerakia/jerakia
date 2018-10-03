policy :default do


  lookup :invalid do
    datasource :file, {
      :docroot    => "test/fixtures/var/lib/jerakia/data",
      :format     => :yaml,
      :searchpath => [
        "invalid",
    ],
    }

    # delieratley break the request object.  This is to ensure
    # that clone_request in lib/jerakia/policy.rb really does
    # give the next lookup a clean request to work with
    request.key = 'bad'
    request.namespace = [ 'bad' ]

  end

  lookup :test_confine do
    datasource :dummy, {
      :return => "Success"
    }

    confine request.namespace[0], "test_conf"
    confine scope[:testing], "yes"
    stop
  end

  lookup :default do
    datasource :file, {
      :docroot    => "test/fixtures/var/lib/jerakia/data",
      :enable_caching => true,
      :searchpath => [
        "host/#{scope[:hostname]}",
        "env/#{scope[:env]}",
        "common",
    ],
    }
    exclude request.key, "skippy"
    output_filter :dig, [ 'beers' ]

#    output_filter :encryption
 #   output_filter :strsub
  end
end

