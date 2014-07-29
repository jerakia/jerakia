class Jacaranda::Datasource
  module File

    attr_reader :file_format
    def load_format_handler
      format = options[:format] || :yaml
      class_name=format.to_s.capitalize
      require "jacaranda/datasource/file/#{format.to_s}"
      @file_format = eval "Jacaranda::Datasource::File::#{class_name}"
    end

    def read_from_file(fname)
      diskname=::File.join(options[:docroot],fname,lookup.request.namespace).gsub(/\/$/,'')
      @file_format.import_file(diskname)
    end


    def run
      #
      # Do the lookup

      Jacaranda::Log.debug("Searching key #{lookup.request.key} from file format #{options[:format]}")
      option :searchpath, Array
      option :format,     Symbol, :yaml
      option :docroot,    String, '/etc/jacaranda'

      load_format_handler

      options[:searchpath].each do |path|
        data=read_from_file(path)
        if data[lookup.request.key]
          response.submit data[lookup.request.key]
        end
      end
      
    end
  end
end

