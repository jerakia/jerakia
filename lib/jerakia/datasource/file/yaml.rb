class Jerakia::Datasource
  module File
    class Yaml
      EXTENSION = 'yaml'.freeze

      class << self
        require 'yaml'
        def convert(data)
          return {} if data.empty?
          begin
            YAML.load(data)
          rescue Psych::SyntaxError => e
            raise Jerakia::FileParseError, "Error parsing YAML document: #{e.message}"
          end
        end
      end
    end
  end
end
