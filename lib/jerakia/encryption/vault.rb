require 'jerakia/util/http'
require 'json'
require 'base64'

class Jerakia
  class Encryption
    module Vault

      def signiture
        /^vault:v[0-9]:[^ ]+$/
      end

      def vault_url(action='decrypt')
        uri = []
        uri << config['vault_addr']
        uri << "v#{config['vault_api_version']}"
        uri << [ 'transit', action ]
        uri << config['vault_keyname']
        uri.flatten.join("/")
      end

      def parse_response(response)
        body = JSON.load(response.body)
        if response.code_type == Net::HTTPOK
          if body['data']
            return body['data']
          else
            return nil
          end
        else
          if body['errors'].is_a?(Array)
            message = body['errors'].join("\n")
          else
            message = "Failed to decrypt entry #{body}"
          end
          raise Jerakia::EncryptionError, "Error decrypting data from Vault: #{message}"
        end
      end
          
      def vault_post(data, action='decrypt')
        url = vault_url(action)
        Jerakia.log.debug("Connecting to vault at #{url}")
        headers = {
          'X-Vault-Token' => config['vault_token'],
        }
        begin
          parse_response Jerakia::Util::Http.post(url, data, headers)
        rescue Jerakia::HTTPError => e
          raise Jerakia::EncryptionError, "Error connecting to Vault service: #{e.message}"
        end
      end

      def decrypt(string)
        response = vault_post({ 'ciphertext' => string})
        Base64.decode64(response['plaintext'])
      end

      def encrypt(plain)
        encoded = Base64.encode64(plain)
        response = vault_post({ 'plaintext' => encoded}, 'encrypt')
        response['ciphertext']
      end


    end
  end
end

