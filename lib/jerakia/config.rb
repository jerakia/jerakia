require 'yaml'

class Jerakia::Config
  attr_reader :policydir
  attr_reader :server_url

  def self.load_from_file(file = '/etc/jerakia/jerakia.yaml')
    Jerakia.crit("Config file #{file} not found") unless File.exists?(file)
    new YAML.load_file(file)
  end

  def initialize(config)
    @policydir = config['policydir']
    @server_url = config['server_url']
    @configdata = config
  end

  def [](key)
    @configdata[key.to_s]
  end
end
