policy :default do

#
#  lookup :invalid do
#    datasource :file, {
#      :docroot    => "test/fixtures/var/lib/jerakia/data",
#      :format     => :yaml,
#      :searchpath => [
#        "invalid",
#    ],
#    }
#
#    # delieratley break the request object.  This is to ensure
#    # that clone_request in lib/jerakia/policy.rb really does
#    # give the next lookup a clean request to work with
#    request.key = 'bad'
#    request.namespace = [ 'bad' ]
#
#  end
#
  lookup :default do
    datasource :file_new, {
      :docroot    => "test/fixtures/var/lib/jerakia/data",
      :enable_caching => true,
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

