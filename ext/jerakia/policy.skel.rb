# Jerakia policy file.
#
# The default policy is called :default, you can add further policies by adding
# them into the policy.d folder as name.rb
#
policy :default do
  # Lookups are initiated in order, each lookup must define at least a datasource
  # to tell Jerakia where to source the data from
  #
  lookup :main do
    datasource :file, :docroot => '/var/lib/jerakia/data',
                      :searchpath => [
                        "hostname/#{scope[:certname]}",
                        "environment/#{scope[:environment]}",
                        'common'
                      ],
                      :format => :yaml
  end
end
