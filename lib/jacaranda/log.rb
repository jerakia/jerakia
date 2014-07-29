class Jacaranda::Log

  class << self

    def debug(message)
      puts "[debug]: #{message}"
    end

    def info(message)
      puts "[info]: #{message}"
    end

    def crit(message)
      puts "[crit]: #{message}"
    end

  end
end

