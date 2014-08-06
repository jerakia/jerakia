require 'faster_require'

class Jacaranda
  require 'jacaranda/policy'
  require 'jacaranda/lookup'
  require 'jacaranda/request'
  require 'jacaranda/log'
  require 'jacaranda/util'
  require 'jacaranda/config'
  require 'jacaranda/launcher'
  require 'jacaranda/cache'




  def initialize(options={})
    configfile = options[:config] || '/etc/jacaranda/jacaranda.yml'
    @@config = Jacaranda::Config.new(configfile)
    @@filecache = {}
    @@cache = Jacaranda::Cache.new
    loglevel = options[:loglevel] || @@config["loglevel"] || "info"
    @@log = Jacaranda::Log.new(loglevel.to_sym)
    @@log.debug("Jacaranda initialized")

  end

  def lookup(request)
    res=Jacaranda::Launcher.new(request)
    return res.answer
  end

  def config
    @@config
  end

  def filecache(name)
    @@filecache[name] ||= File.read(name)
    return @@filecache[name]
  end

  def add_to_filecache(name,data)
    @@filecache[name] = data
  end

  def log
    @@log
  end

  def self.crit(msg)
    Jacaranda::Log.crit msg
    exit 1 
  end
end

