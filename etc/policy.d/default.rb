    policy :default do

      lookup :default, :use => :basler_hostname  do
        puts basler_env
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
