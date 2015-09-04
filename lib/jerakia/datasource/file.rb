require 'jerakia/cache/file'


class Jerakia::Datasource
  module File

    attr_reader :file_format
    @@cache = Jerakia::Cache::File.new

    def load_format_handler
      format = options[:format] || :yaml
      class_name=format.to_s.capitalize
      require "jerakia/datasource/file/#{format.to_s}"
      @file_format = eval "Jerakia::Datasource::File::#{class_name}"
    end


    def cache
      @@cache
    end

    def read_from_file(fname)
      fpath = []
      fpath << options[:docroot] unless fname[0] == '/'
      fpath << [ fname, lookup.request.namespace ]

      extension = options[:extension] || @file_format::EXTENSION
      diskname = "#{::File.join(fpath.flatten).gsub(/\/$/, '')}.#{extension}"
      

      Jerakia.log.debug("read_from_file()  #{diskname}")

     
      if options[:enable_caching]
        if cache.valid?(diskname) 
          Jerakia.log.debug("Returning cached data")
          cache.get(diskname)
        else
          Jerakia.log.debug("Adding contents of #{diskname} to cache")
          cache.add(diskname,@file_format.import_file(diskname))
        end
      else
        @file_format.import_file(diskname)
      end
    end


    def run
      #
      # Do the lookup

      Jerakia.log.debug("Searching key #{lookup.request.key} from file format #{options[:format]} (#{whoami})")
      option :searchpath, { :type => Array,  :mandatory => true }
      option :format,     { :type => Symbol, :default => :yaml }
      option :docroot,    { :type => String, :default => "/etc/jerakia/data" }
      option :extension,  { :type => String }

      load_format_handler

      options[:searchpath].each do |path|
        Jerakia.log.debug("Attempting to load data from #{path}")
        return unless response.want?
        data=read_from_file(path)
        Jerakia.log.debug("Datasource provided #{data} looking for key #{lookup.request.key}")
        if data[lookup.request.key]
          Jerakia.log.debug("Found data #{data[lookup.request.key]}")
          response.submit data[lookup.request.key]
        end
      end
      
    end
  end
end

