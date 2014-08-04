# Parts of this class are copied from https://github.com/TomPoulton/hiera-eyaml/blob/master/lib/hiera/backend/eyaml_backend.rb
# The MIT License (MIT)
#
# Copyright (c) 2013 Tom Poulton
#
# Other code Copyright (c) 2014 Craig Dunn, Apache 2.0 License.
#
require 'hiera/backend/eyaml/encryptor'
require 'hiera/backend/eyaml/utils'
require 'hiera/backend/eyaml/options'
require 'hiera/backend/eyaml/parser/parser'
require 'hiera/filecache'

require 'yaml'
#
class Jacaranda::Response
  module Filter
    module Encryption

      def filter_encryption
        puts "ENC"
        parse_values do |val|
          if val.is_a?(String)
            decrypt val
            val
          end
        end
      end

      def decrypt(data)
        if encrypted?(data)
          Jacaranda::Log.debug("Attempting to decrypt")
          # Move this to Jacaranda::Config... ->
          Hiera::Backend::Eyaml::Options[:pkcs7_private_key] = '/Users/craigdunn/jacaranda/etc/secure/keys/private_key.pkcs7.pem'
          Hiera::Backend::Eyaml::Options[:pkcs7_public_key] = '/Users/craigdunn/jacaranda/etc/secure/keys/public_key.pkcs7.pem'
          parser = Hiera::Backend::Eyaml::Parser::ParserFactory.hiera_backend_parser
          
          tokens = parser.parse(data)
          decrypted = tokens.map{ |token| token.to_plain_text }
          plaintext = decrypted.join
          Jacaranda::Log.debug(plaintext)
          plaintext.chomp!
          data.clear.insert(0,plaintext)
        else
          data
        end
      end


      def encrypted?(data)
        /.*ENC\[.*?\]/ =~ data ? true : false
      end


    end
  end
end


