

policy :puppet do


  lookup :dummy do {
    datasource :dummy
  lookup :default do
    datasource :file, {
      :format => :yaml,
      :enable_caching => true,
      :docroot => "/var/lib/jacaranda",
      :searchpath => [
        "hostname/#{scope[:fqdn]}",
        "hostgroup/#{scope[:kt_org]}/#{scope[:hostgroup]}",
        "hostgroup/#{scope[:hostgroup]}/#{scope[:calling_module]}",
        "appgroup/#{scope[:appgroup]}/#{scope[:calling_module]}",
        "appgroup/#{scope[:appgroup]}/#{scope[:location]}/#{scope[:calling_module]}",
        "location/#{scope[:location]}",
        #"common/#{scope[:operatingsystem]}/#{scope[:operatingsystemmajrelease]}/#{scope[:calling_module]}",
        "common/#{calling_module}"
      ],
    }
    hiera_compat
  end
end


    
