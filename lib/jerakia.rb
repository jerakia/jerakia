
class Jerakia
  require 'jerakia/policy'
  require 'jerakia/lookup'
  require 'jerakia/request'
  require 'jerakia/log'
  require 'jerakia/util'
  require 'jerakia/config'
  require 'jerakia/launcher'
  require 'jerakia/cache'
  require 'jerakia/version'

  def initialize(options={})
    configfile = options[:config] || ENV['JERAKIA_CONFIG'] ||  '/etc/jerakia/jerakia.yaml'
    @@config = Jerakia::Config.load_from_file(configfile)

    if @@config[:plugindir]
      $LOAD_PATH << @@config[:plugindir] unless $LOAD_PATH.include?(@@config[:plugindir])
    end

    @@filecache = {}
    loglevel = options[:loglevel] || @@config["loglevel"] || "info"
    logfile = options[:logfile] || @@config["logfile"] || "/var/log/jerakia.log"
    @@log = Jerakia::Log.new(loglevel.to_sym, logfile)
    @@log.debug("Jerakia initialized")
  end

  def lookup(request)
    Jerakia::Launcher.new(request) { invoke_from_file }.answer
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
    fail msg
  end
end
