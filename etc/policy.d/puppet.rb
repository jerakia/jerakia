
policy :puppet do

#  lookup :dummy do
#    datasource :dummy, {
#      :return => "hello world"
#    }
#
  lookup :default do
    datasource :file, {
      :format => :yaml,
      :docroot => '/root/basler_hiera',
      #:extension => 'yaml',
      :searchpath => [
        "/tmp/test",
        "common"
      ]
    }
  end

#    datasource :file, {
#      :format => :yaml,
#      :docroot => "/Users/craigdunn/jacaranda/etc/data",
#      :searchpath => [
##        "#{scope[:environment]}",
#        'global',
#        'common'
#    ]
#    }
#
#    exclude :environment, "production"
#    hiera_compat


end

 
