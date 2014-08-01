class Jacaranda::Config

  require 'yaml'
  attr_reader :policydir
  attr_reader :server_url

  def initialize(config='/Users/craigdunn/jacaranda/etc/jacaranda.yml')
    Jacaranda::Log.debug('initialized config class')
    rawdata=File.read(config)
    ymldata=YAML.load(rawdata)
    p ymldata
    @policydir=ymldata['policydir']
    @server_url=ymldata['server_url']

  end
end


