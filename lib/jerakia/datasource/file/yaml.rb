class Jerakia::Datasource
  module File
    class Yaml

      EXTENSION='yaml'

      class << self
        require 'yaml'
        def convert(data)
          return {} if data.empty?
          YAML.load(data)
        end
      end
    end
  end
end

