# Class Jerakia
#
# Main Jerakia class
#
class Jerakia
  require 'english'
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

  attr_reader :options

  class << self
    attr_reader :config
    attr_reader :log
    attr_reader :filecache
  end

  @config = nil
  @filecache = {}
  @log = nil

  def initialize(options = {})
    @options = options

    load_config
    load_log_handler

    if config[:plugindir]
      $LOAD_PATH << config[:plugindir] unless $LOAD_PATH.include?(config[:plugindir])
    end

    log.debug('Jerakia initialized')
    Jerakia.log.verbose("Jerakia started. Version #{Jerakia::VERSION}")
  end

  def lookup(request)
    lookup_instance = Jerakia::Launcher.new(request)
    lookup_instance.invoke_from_file
    lookup_instance.answer
  rescue Jerakia::Error => e
    Jerakia.fatal(e.message, e)
  end

  def self.fatal(msg, e)
    stacktrace = e.backtrace.join("\n")
    Jerakia.log.fatal msg
    Jerakia.log.fatal "Full stacktrace output:\n#{$ERROR_INFO}\n\n#{stacktrace}"
    raise e
  end

  def filecache
    self.class.filecache
  end

  def config
    self.class.config
  end

  def log
    self.class.log
  end

  def self.filecache(name)
    begin
      @filecache[name] ||= File.read(name)
    rescue Errno::ENOENT => e
      raise Jerakia::Error, "Could not read file #{name}, #{e.message}"
    end
    @filecache[name]
  end

  class << self
    def config=(data)
      @config ||= data
    end

    def log=(logger)
      @log ||= logger
    end
  end

  private

  def configfile
    options[:config] || ENV['JERAKIA_CONFIG'] || '/etc/jerakia/jerakia.yaml'
  end

  def config_instance
    File.exist?(configfile) ? Jerakia::Config.load_from_file(configfile) : Jerakia::Config.new
  end

  def load_config
    self.class.config = config_instance
  end

  def loglevel
    options[:loglevel] || config['loglevel'] || 'info'
  end

  def logfile
    options[:logfile] || config['logfile'] || '/var/log/jerakia.log'
  end

  def load_log_handler
    self.class.log = Jerakia::Log.new(loglevel.to_sym, logfile)
  end
end
