class Jerakia
  class Encryption
    module Dummy
      def signiture
        /^vault:v[0-9]:[^ ]+$/
      end

      def decrypt(str)
        'wibble'
      end
    end
  end
end

 
