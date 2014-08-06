class Jacaranda::Config

  require 'yaml'
  attr_reader :policydir
  attr_reader :server_url

  def initialize(config='/etc/jacaranda/jacaranda.yml')
    unless File.exists?(config)
      Jacaranda.crit("Config file #{config} not found")
    end
    rawdata=File.read(config)
    ymldata=YAML.load(rawdata)
    @policydir=ymldata['policydir']
    @server_url=ymldata['server_url']
    @configdata=ymldata
  end

  def [](key)
    @configdata[key.to_s]
  end


end


