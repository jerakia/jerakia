class Jacaranda::Log < Jacaranda

  require 'logger'
  def initialize(level=:info)
    @@logfile ||= config[:logfile] || '/var/log/jacaranda.log'
    @@logger ||= Logger.new(@@logfile)
    @@level ||= level
    case @@level
    when :info
      @@logger.level = Logger::INFO
    when :debug
      @@logger.level = Logger::DEBUG
    end
  end

  def info(msg)
    @@logger.info msg
  end

  def debug(msg)
    @@logger.debug msg
  end

  def self.debug(msg)
    self.new.debug msg
  end

  def self.info(msg)
    self.new.info msg
  end



end

