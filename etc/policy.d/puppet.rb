policy :craig do
  lookup :default do
    datasource :file, {
      :format => :yaml,
      :docroot => '../etc',
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

  lookup :secondary do
    datasource :file, {
      :docroot => '../etc',
      :searchpath => [
        "#{scope[:environment]}",
        'global',
        'common'
    ],
    }
    hiera_compat
  end

end

 
