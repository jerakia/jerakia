class Jacaranda::Config

  require 'yaml'
  attr_reader :policydir
  attr_reader :server_url

  def initialize(config='/etc/jacaranda/jacaranda.yml')
    Jacaranda::Log.debug('initialized config class')
    unless File.exists?(config)
      Jacaranda.crit("Config file #{config} not found")
    end
    rawdata=File.read(config)
    ymldata=YAML.load(rawdata)
    p ymldata
    @policydir=ymldata['policydir']
    @server_url=ymldata['server_url']
    @configdata=ymldata
  end

  def [](key)
    @configdata[key]
  end


end


