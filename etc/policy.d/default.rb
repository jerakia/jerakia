    policy :default do
     
      lookup :default, :use => [  :basler, :hiera ]  do
        puts plugin.basler.env
        datasource :file, {
          :format     => :yaml,
          :docroot    => "/var/lib/jerakia",
          :enable_caching => true,
          :searchpath => [
            plugin.basler.hostgroup_tree,
            "hostname/#{scope[:fqdn]}",
            "environment/#{scope[:environment]}",
            "common",
           ].flatten,
        }
        plugin.hiera.rewrite_lookup
      end

    end
