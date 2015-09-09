    policy :default do
     
      lookup :default, :use => [  :basler, :hiera ]  do
        datasource :file, {
          :format     => :yaml,
          :docroot    => "/var/lib/jerakia",
          :enable_caching => true,
          :searchpath => [
            "hostname/#{scope[:fqdn]}",
            "environment/#{scope[:environment]}",
            "commooon",
           ].flatten,
        }
        plugin.hiera.rewrite_lookup
        confine scope[:environment], [ "bar", "dev", "development.*", "wow" ]
      end

    end
