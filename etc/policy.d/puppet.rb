
policy :puppet do

  
  lookup :default do
    datasource :file, {
      :format => :yaml,
      :docroot => "/Users/craigdunn/jacaranda/etc/data",
      :searchpath => [
        "#{scope[:environment]}",
        'global',
        'common'
    ]
    }

    exclude :environment, "production"
    output_filter :encryption
    hiera_compat
  end

  datamodel :strict


end

 
