#require 'faster_require'

class Jerakia
  require 'jerakia/policy'
  require 'jerakia/lookup'
  require 'jerakia/request'
  require 'jerakia/log'
  require 'jerakia/util'
  require 'jerakia/config'
  require 'jerakia/launcher'
  require 'jerakia/cache'

  def initialize(options={})
    configfile = options[:config] || '/etc/jerakia/jerakia.yaml'
    @@config = Jerakia::Config.new(configfile)

    if @@config[:plugindir]
      $LOAD_PATH << @@config[:plugindir] unless $LOAD_PATH.include?(@@config[:plugindir])
    end

    @@filecache = {}
    loglevel = options[:loglevel] || @@config["loglevel"] || "info"
    @@log = Jerakia::Log.new(loglevel.to_sym)
    @@log.debug("Jerakia initialized")
  end

  def lookup(request)
    res=Jerakia::Launcher.new(request)
    return res.answer
  end

  def config
    @@config
  end


  def self.fatal(msg,e)
    stacktrace=e.backtrace.join("\n")
    Jerakia.log.fatal msg
    Jerakia.log.fatal "Full stacktrace output:\n#{$!}\n\n#{stacktrace}"
    puts "Fatal error, check log output for details"
    throw Exception
  end

  def self.filecache(name)
    @@filecache[name] ||= File.read(name)
    return @@filecache[name]
  end

  def add_to_filecache(name,data)
    @@filecache[name] = data
  end

  def self.config
    @@config
  end


  def log
    @@log
  end


  def self.log
    @@log
  end

  def self.crit(msg)
    puts msg
    throw Exception
  end
end
