class Jerakia
  class Encryption

    @handler = nil

    class << self
      def handler
        @handler || @handler = self.new
      end
    end

    attr_reader :loaded

    def initialize(provider=nil)
      if provider.nil?
        provider = config["provider"]
      end

      return nil if provider.nil?

      begin
        require "jerakia/encryption/#{provider}"
      rescue LoadError => e
        raise Jerakia::Error, "Failed to load encryption provider #{provider}"
      end

      begin
        eval "extend Jerakia::Encryption::#{provider.capitalize}"
      rescue NameError => e
        raise Jerakia::Error, "Encryption provider #{provider} did not provide class"
      end
      @loaded = true
    end

    def loaded?
      loaded
    end

    def features?(feature)
      case feature
      when :encrypt
        respond_to?('encrypt')
      when :decrypt
        respond_to?('decrypt')
      else
        false
      end
    end

    def self.config
      Jerakia.config[:encryption] || {}
    end

    def config
      self.class.config
    end

  end
end

