require 'jerakia/server/auth/token'
require 'securerandom'

class Jerakia
  class Server
    class Auth

      class << self

        def generate_token
          SecureRandom.hex(40)
        end

        def get_entry(api_id)
          Jerakia::Server::Auth::Token.get(api_id)
        end

        def update(api_id, fields)
          entry = get_entry(api_id)
          entry.update(fields)
          entry.save
        end

        def seen!(api_id)
          update(api_id, { :last_seen => DateTime.now })
        end

        def disable(api_id)
          update(api_id, { :active => false })
        end

        def enable(api_id)
          update(api_id, { :active => true })
        end

        def destroy(api_id)
          entry = get_entry(api_id)
          entry.destroy
        end

        def exists?(api_id)
          get_entry(api_id)
        end

        def create(api_id, token=nil)
          raise Jerakia::Error, "API ID #{api_id} already exists" if exists?(api_id)
	  token = generate_token if token.nil?
          entry = Jerakia::Server::Auth::Token.new(:api_id => api_id, :token => token)
          entry.save
          api_id + ":" + token
        end

        def get_tokens
          Jerakia::Server::Auth::Token.find
        end

        def authenticate(token_string)
          api_id, token = token_string.split(/:/)
          entry = get_entry(api_id)
          return false if entry.nil?
          if entry.token == token and entry.active
            seen!(api_id)
            true
          else
            false
          end
        end
      end
    end
  end
end
