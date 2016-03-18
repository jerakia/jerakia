require 'yaml'

class Jerakia::Config
  attr_reader :policydir
  attr_reader :server_url

  def self.load_from_file(file = '/etc/jerakia/jerakia.yaml')
    new YAML.load_file(file)
  end

  def initialize(config = {})
    config_with_defaults = defaults.merge(config)
    @policydir = config_with_defaults['policydir']
    @server_url = config_with_defaults['server_url']
    @configdata = config_with_defaults
  end

  def defaults
    {
      'policydir' => '/etc/jerakia/policy.d',
      'logfile'   => '/var/log/jerakia.log',
      'loglevel'  => 'info'
    }
  end

  def [](key)
    @configdata[key.to_s]
  end
end
