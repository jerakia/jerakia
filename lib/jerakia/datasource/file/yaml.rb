class Jerakia::Datasource
  module File
    class Yaml

      EXTENSION='yaml'

      class << self
      require 'yaml'
      def import_file(fname)
        Jerakia.log.debug("scanning file #{fname}")
        return {} unless ::File.exists?(fname)
        data=::File.read(fname)
        YAML.load(data)
      end
      end
    end
  end
end

