class Jerakia::Datasource
  class File
     module Yaml
       EXTENSION = 'yaml'.freeze
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
