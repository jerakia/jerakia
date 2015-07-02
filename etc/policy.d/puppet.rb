
policy :puppet do

  lookup :dummy do
    datasource :dummy, {
      :return => "hello world"
    }

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


end

 
