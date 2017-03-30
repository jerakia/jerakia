require 'jerakia/encryption'

class Jerakia::Response
  module Filter
    module Encryption
      def filter_encryption(_opts = {})
        Jerakia.log.debug("Encryption filter started")
        provider = Jerakia::Encryption.new
        unless provider.respond_to?('signiture')
          raise Jerakia::Error, 'Encryption provider did not provide a signiture method, cannot run output filter'
        end

        signiture = provider.signiture
        raise Jerakia::Error, "Encryption provider signiture is not a Regexp" unless signiture.is_a?(Regexp)

        parse_values do |val|
          if val =~ signiture
            decrypted = provider.decrypt(val)
            val.clear.insert(0, decrypted)
          end
          val
        end
      end
    end
  end
end
