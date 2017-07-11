require 'jerakia/util/http'
require 'json'
require 'base64'

class Jerakia
  class Encryption
    module Vault
      class AuthenticationError < Jerakia::Error
      end

      attr_reader :approle_token
      attr_reader :vault_ssl_key
      attr_reader :vault_ssl_cert

      def signiture
        /^vault:v[0-9]:[^ ]+$/
      end

      def config
        {
          "vault_keyname" => "jerakia",
          "vault_addr" => "https://127.0.0.1:8200",
          "vault_use_ssl" => true,
          "vault_ssl_verify" => true,
          "vault_token" => ENV['VAULT_TOKEN'] || nil,
          "vault_api_version" => 1
       }.merge(self.class.config)
      end
  


      def vault_url(endpoint)
        uri = []
        uri << config['vault_addr']
        uri << "v#{config['vault_api_version']}"
        uri << endpoint
        uri.flatten.join("/")
      end

      def login
        Jerakia.log.debug('Requesting new token from Vault server')
        role_id = config['vault_role_id']
        secret_id = config['vault_secret_id']

        login_data = { "role_id" => role_id }
        login_data['secret_id'] = secret_id unless secret_id.nil?

        response = vault_post(login_data, :login, false)
        @approle_token = response['auth']['client_token']
        Jerakia.log.debug("Recieved authentication token from vault server, ttl: #{response['auth']['lease_duration']}")
      end

      def ssl?
        config['vault_use_ssl']
      end

      def read_file(file)
        raise Jerakia::EncryptionError, "Cannot read #{file}" unless File.exists?(file)
        File.read(file)
      end

      def ssl_key
        return nil if config['vault_ssl_key'].nil?
        @vault_ssl_key ||= read_file(config['vault_ssl_key'])
        vault_ssl_key
      end

      def ssl_cert
        return nil if config['vault_ssl_cert'].nil?
        @vault_ssl_cert ||= read_file(config['vault_ssl_cert'])
        vault_ssl_cert
      end


      def token_configured?
        not config['vault_token'].nil?
      end

      def token
        authenticate
        config['vault_token'] || approle_token
      end

      def authenticate
        unless token_configured?
          login if approle_token.nil?
        end
      end

      def endpoint(action)
        {
          :decrypt => "transit/decrypt/#{config['vault_keyname']}",
          :encrypt => "transit/encrypt/#{config['vault_keyname']}",
          :login   => "auth/approle/login"
        }[action]
      end 

      def url_path(action)
        vault_url(endpoint(action))
      end

          

      def parse_response(response)
        body = JSON.load(response.body)
        if response.code_type == Net::HTTPOK
          return body
        else
          if response.code == "403"
            raise Jerakia::Encryption::Vault::AuthenticationError, body
          end
          if body['errors'].is_a?(Array)
            message = body['errors'].join("\n")
          else
            message = "Failed to decrypt entry #{body}"
          end
          raise Jerakia::EncryptionError, "Error decrypting data from Vault: #{message}"
        end
      end
          
      def vault_post(data, action, use_token=true, headers={})
        url = url_path(action)
        http_options = {}

        if ssl?
          http_options = {
            :ssl        => true,
            :ssl_verify => config['vault_ssl_verify'],
            :ssl_cert   => ssl_cert,
            :ssl_key    => ssl_key,
          }
        end

        Jerakia.log.debug("Connecting to vault at #{url}")
        tries = 0
        begin
          headers['X-Vault-Token'] = token if use_token
          tries += 1
          parse_response Jerakia::Util::Http.post(url, data, headers, http_options)
        rescue Jerakia::Encryption::Vault::AuthenticationError => e
          Jerakia.log.debug("Encountered Jerakia::Encryption::Vault::AuthenticationError, retrying with new token (#{tries})")

          login
          retry if tries < 2
          raise
        rescue Jerakia::HTTPError => e
          raise Jerakia::EncryptionError, "Error connecting to Vault service: #{e.message}"
        end
      end

      def decrypt(string)
        response = vault_post({ 'ciphertext' => string}, :decrypt)
        response_data=response['data']
        Base64.decode64(response_data['plaintext'])
      end

      def encrypt(plain)
        encoded = Base64.encode64(plain)
        response = vault_post({ 'plaintext' => encoded}, :encrypt)
        response_data=response['data']
        response_data['ciphertext']
      end


    end
  end
end

