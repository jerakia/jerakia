class Jerakia::Datasource
  module File
    class Yaml
      class << self
      require 'yaml'
      def import_file(fname, extension='yml')
        diskfile="#{fname}.#{extension}"
        Jerakia.log.debug("scanning file #{diskfile}")
        return {} unless ::File.exists?(diskfile)
        data=::File.read(diskfile)
        YAML.load(data)
      end
      end
    end
  end
end

