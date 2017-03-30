class Jerakia
  class Encryption

    def initialize(provider=nil)
      if provider.nil?
        provider = config["provider"]
      end

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
      overrides = Jerakia.config[:encryption]
      defaults = {
        "provider" => "vault",
        "vault_keyname" => "jerakia",
        "vault_addr" => "https://127.0.0.1:8200",
        "vault_token" => ENV['VAULT_TOKEN'] || nil,
        "vault_api_version" => 1
      }
      defaults.merge(overrides)
    end

    def config
      self.class.config
    end

  end
end

