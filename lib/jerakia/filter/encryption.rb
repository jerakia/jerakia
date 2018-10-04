require 'jerakia/encryption'

class Jerakia
  class Filter
    class Encryption < Jerakia::Filter

      def filter
        Jerakia.log.debug("Encryption filter started")
        provider = Jerakia::Encryption.handler

        unless provider.loaded?
          raise Jerakia::Error, 'Cannot load encryption output filter, no encryption provider configured'
        end
        unless provider.respond_to?('signiture')
          raise Jerakia::Error, 'Encryption provider did not provide a signiture method, cannot run output filter'
        end

        signiture = provider.signiture
        raise Jerakia::Error, "Encryption provider signiture is not a Regexp" unless signiture.is_a?(Regexp)

        # Match the signiture of the provider (from the signiture method) against the string
        # if the string matches the regex then call the decrypt method of the encryption
        # provider
        #
        all_keys do |key|
          key.parse_values do |val|
            if val =~ signiture
              decrypted = provider.decrypt(val)
              val.clear.insert(0, decrypted)
            end
          end
        end
      end
    end
  end
end
