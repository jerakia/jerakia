class Jacaranda
  require 'jacaranda/policy'
  require 'jacaranda/lookup'
  require 'jacaranda/request'
  require 'jacaranda/log'
  require 'jacaranda/util'
  require 'jacaranda/config'
  require 'jacaranda/launcher'




  def initialize
    @@config = Jacaranda::Config.new
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

