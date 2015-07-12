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

  def error(msg)
    @@logger.error msg
  end

  def fatal(msg)
    @@logger.fatal msg
  end

#  def self.fatal(msg)
#    self.new.fatal msg
#  end 
#
#  def self.error(msg)
#    self.new.error msg
#  end
#
  def self.debug(msg)
    self.new.debug msg
  end
#
##  def self.info(msg)
#    puts @@logger
#    self.new.info msg
#  end



end

