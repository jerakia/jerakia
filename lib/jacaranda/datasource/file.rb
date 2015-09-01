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

      Jacaranda.log.debug("read_from_file() #{fname} using diskname #{diskname}")

      import_args=[]
      import_args << diskname
      import_args << options[:extension] if options[:extension]

      cache_index={ :diskname => diskname, :format => options[:format] }
      if options[:enable_caching]
        if in_bucket?(cache_index) 
          Jacaranda.log.debug("returning cached data #{bucket[cache_index]}")
          bucket[cache_index]
        else
          Jacaranda.log.debug("adding to cache #{@file_format.import_file(*import_args)}")
          bucket_add(cache_index,@file_format.import_file(*import_args))
        end
      else
        @file_format.import_file(*import_args)
      end
    end


    def run
      #
      # Do the lookup

      Jacaranda.log.debug("Searching key #{lookup.request.key} from file format #{options[:format]} (#{whoami})")
      option :searchpath, { :type => Array,  :mandatory => true }
      option :format,     { :type => Symbol, :default => :yaml }
      option :docroot,    { :type => String, :default => "/etc/jacaranda/data" }
      option :extension,  { :type => String }

      load_format_handler

      options[:searchpath].each do |path|
        Jacaranda.log.debug("Attempting to load data from #{path}")
        return unless response.want?
        data=read_from_file(path)
        Jacaranda.log.debug("Datasource provided #{data} looking for key #{lookup.request.key}")
        if data[lookup.request.key]
          Jacaranda.log.debug("Found data #{data[lookup.request.key]}")
          response.submit data[lookup.request.key]
        end
      end
      
    end
  end
end

