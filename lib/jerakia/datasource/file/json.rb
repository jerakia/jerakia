class Jerakia::Datasource
  class File
    module Json
      EXTENSION = 'json'.freeze

      require 'json'
      def convert(data)
        return {} if data.empty?
        begin
          JSON.load(data)
        rescue JSON::ParserError => e
          raise Jerakia::FileParseError, "Could not parse JSON content, #{e.message}"
        end
      end
    end
  end
end
