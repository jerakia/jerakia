class Jacaranda::Config

  require 'yaml'
  attr_reader :policydir

  def initialize(config='/Users/craigdunn/jacaranda/etc/jacaranda.yml')
    Jacaranda::Log.debug('initialized config class')
    rawdata=File.read(config)
    ymldata=YAML.load(rawdata)
    p ymldata
    @policydir=ymldata['policydir']
  end
end


