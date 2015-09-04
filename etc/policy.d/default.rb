    policy :default do

      lookup :default do
        datasource :file, {
          :format     => :yaml,
          :docroot    => "/var/lib/jerakia",
          :enable_caching => true,
          :searchpath => [
            "hostname/#{scope[:fqdn]}",
            "environment/#{scope[:environment]}",
            "common",
           ],
        }
      end

    end
