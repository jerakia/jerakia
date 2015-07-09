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
      fpath = []
      fpath << options[:docroot] unless fname[0] == '/'
      fpath << [ fname, lookup.request.namespace ]
      diskname = ::File.join(fpath.flatten).gsub(/\/$/, '')

      cache_index={ :diskname => diskname, :format => options[:format] }
      if options[:enable_caching]
        if in_bucket?(cache_index) 
          bucket[cache_index]
        else
          bucket_add(cache_index,@file_format.import_file(diskname))
        end
      else
        @file_format.import_file(diskname)
      end
    end


    def run
      #
      # Do the lookup

      Jacaranda::Log.debug("Searching key #{lookup.request.key} from file format #{options[:format]} (#{whoami})")
      option :searchpath, { :type => Array,  :mandatory => true }
      option :format,     { :type => Symbol, :default => :yaml }
      option :docroot,    { :type => String, :default => "/etc/jacaranda/data" }
      option :extension,  { :type => String }

      load_format_handler

      options[:searchpath].each do |path|
        return unless response.want?
        data=read_from_file(path)
        if data[lookup.request.key]
          response.submit data[lookup.request.key]
        end
      end
      
    end
  end
end

