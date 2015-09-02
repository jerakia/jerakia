    policy :default do

      lookup :default do
        datasource :file, {
          :format     => :yaml,
          :docroot    => "/var/lib/jacaranda",
          :searchpath => [
            "hostname/#{scope[:fqdn]}",
            "environment/#{scope[:environment]}",
            "common",
           ],
        }
      end

    end
