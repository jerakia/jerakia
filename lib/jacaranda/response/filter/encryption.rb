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

class Jacaranda::Response
  module Filter
    module Encryption

      def filter_encryption(opts={})
        parse_values do |val|
          if val.is_a?(String)
            decrypt val
          end
          val
        end
      end

      def decrypt(data)
        if encrypted?(data)
          public_key = config["eyaml"]["public_key"]
          private_key = config["eyaml"]["private_key"]
          Hiera::Backend::Eyaml::Options[:pkcs7_private_key] = private_key
          Hiera::Backend::Eyaml::Options[:pkcs7_public_key] = public_key
          parser = Hiera::Backend::Eyaml::Parser::ParserFactory.hiera_backend_parser
          
          tokens = parser.parse(data)
          decrypted = tokens.map{ |token| token.to_plain_text }
          plaintext = decrypted.join
          Jacaranda.log.debug(plaintext)
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


