class Jacaranda
  require 'jacaranda/policy'
  require 'jacaranda/lookup'
  require 'jacaranda/request'
  require 'jacaranda/log'
  require 'jacaranda/util'
  require 'jacaranda/config'
  require 'jacaranda/launcher'




  def initialize(options={})
    configfile = options[:config] || '/etc/jacaranda/jacaranda.yml'
    Jacaranda::Log.debug("Jacaranda initialized with config #{configfile}")
    @@config = Jacaranda::Config.new(configfile)
  end

  def lookup(request)
    res=Jacaranda::Launcher.new(request)
    return res.answer
  end

  def config
    @@config
  end


  def self.crit(msg)
    Jacaranda::Log.crit msg
    exit 1 
  end
end

