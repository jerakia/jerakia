
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
  require 'jerakia/error'

  attr_reader :trace

  def initialize(options={})

    configfile = options[:config] || ENV['JERAKIA_CONFIG'] || '/etc/jerakia/jerakia.yaml'
    @@config = File.exist?(configfile) ? Jerakia::Config.load_from_file(configfile) : Jerakia::Config.new


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
    begin
      lookup_instance = Jerakia::Launcher.new(request)
      lookup_instance.invoke_from_file
      lookup_instance.answer
    rescue Jerakia::Error => e
      Jerakia.fatal(e.message, e, trace)
    end

  end

  def config
    @@config
  end

  def self.fatal(msg,e, trace=false)
    stacktrace=e.backtrace.join("\n")
    Jerakia.log.fatal msg
    Jerakia.log.fatal "Full stacktrace output:\n#{$!}\n\n#{stacktrace}"
    raise e
  end

  def self.filecache(name)
    begin
      @@filecache[name] ||= File.read(name)
    rescue Errno::ENOENT => e
      raise Jerakia::Error, "Could not read file #{name}, #{e.message}"
    end
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
