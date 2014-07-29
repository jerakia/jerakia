policy :puppet do

  lookup :yaml do
    datasource :yaml, {
      :datadir    => '/etc/puppet/hieradata',
      :searchpath => [
        'global',
        "hosts/#{scope.hostname}",
        "env/#{scope.environment}",
        "global"
    ],
      confine :environment, "dev"
  end

  lookup :http do
    datasource :http, {
      :url  => 'http://localhost:8800',
      :searchpath => [
        "/configuration/#{scope.environment}/?#{key}",
    ],
    confine :calling_module, "myapplication"
    exclude :environment, "sandbox"
  end
    
end
