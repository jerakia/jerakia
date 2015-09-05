    policy :default do
     
      lookup :default, :use => [  :basler, :craig ]  do
        puts plugin.basler.env
        puts plugin.craig.test
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
      end

    end
