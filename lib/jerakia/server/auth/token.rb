require 'data_mapper'
require 'dm-sqlite-adapter'
require 'bcrypt'
require 'jerakia'
require 'jerakia/config'
class Jerakia
  class Server
    class Auth

      Jerakia.log.debug("Authentication database sqlite://#{Jerakia.config[:vardir]}/tokens.db")
      DataMapper.setup(:default, "sqlite://#{Jerakia.config[:vardir]}/tokens.db")

      class Token

        include DataMapper::Resource
        include BCrypt

        property :api_id, String, :key => true
        property :token, BCryptHash
        property :active, Boolean, :default => true
        property :last_seen, DateTime, :default => DateTime.now
      end

      DataMapper.finalize
      DataMapper.auto_upgrade!
    end
  end
end


