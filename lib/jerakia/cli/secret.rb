require 'jerakia/encryption'
require 'jerakia'

class Jerakia
  class CLI < Thor
    module Secret
      class Secret < Thor
        
        Jerakia.new
        @provider = Jerakia::Encryption.new

        class << self
          attr_reader :provider
        end

        no_commands do
          def provider
            self.class.provider
          end
        end

        if @provider.features?(:decrypt)
          desc 'decrypt <encrypted value>', 'Decrypt an encrypted value'
          def decrypt(encrypted)
            begin
              plaintext = provider.decrypt(encrypted)
            rescue Jerakia::EncryptionError => e
              puts e.message
              exit(1)
            end
            puts plaintext
          end
        end

        if @provider.features?(:encrypt)
          desc 'encrypt <string>', 'Encrypt a plain text string'
          def encrypt(plaintext)
            begin
              encrypted = provider.encrypt(plaintext)
            rescue Jerakia::EncryptionError => e
              puts e.message
              exit(1)
            end
            puts encrypted
          end
        end
      end

      def self.included(thor)
        thor.class_eval do
          info = Secret.provider.loaded? ? "" : "(No encryption provider configured!)"
          desc 'secret [SUBCOMMAND] <options>', "Manage encrypted secrets #{info}"
          subcommand 'secret', Secret
        end
      end
    end
  end
end
