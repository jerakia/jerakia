require 'jerakia/cache/file'

class Jerakia::Datasource
  module File
    attr_reader :file_format
    @@cache = Jerakia::Cache::File.new

    def load_format_handler
      format = options[:format] || :yaml
      class_name = format.to_s.capitalize
      require "jerakia/datasource/file/#{format}"
      @file_format = eval "Jerakia::Datasource::File::#{class_name}"
    end

    def cache
      @@cache
    end

    def import_file(filename)
      Jerakia.log.debug("import_file() Importing #{filename}")
      if ::File.exist?(filename)
        ::File.read(filename)
      else
        ''
      end
    end

    def get_file_with_cache(diskname)
      if options[:enable_caching]
        if cache.valid?(diskname)
          Jerakia.log.debug('Returning cached data')
          cache.get(diskname)
        else
          Jerakia.log.debug("Adding contents of #{diskname} to cache")
          cache.add(diskname, import_file(diskname))
        end
      else
        import_file(diskname)
      end
    end

    def list_fragments(prefix, extension)
      Dir["#{prefix}.d/*.#{extension}"] if ::File.directory?("#{prefix}.d")
    end

    def read_from_file(fname)
      fpath = []
      fpath << options[:docroot] unless fname[0] == '/'
      fpath << [fname, lookup.request.namespace]

      extension = options[:extension] || @file_format::EXTENSION
      diskname_prefix = ::File.join(fpath.flatten).gsub(/\/$/, '').to_s
      diskname = "#{diskname_prefix}.#{extension}"

      files = [diskname]
      files << list_fragments(diskname_prefix, extension)

      raw_data = ''

      files.flatten.compact.each do |f|
        Jerakia.log.debug("read_from_file()  #{f}")
        raw_data << get_file_with_cache(f)
      end

      begin
        file_format.convert(raw_data)
      rescue Jerakia::FileParseError => e
        raise Jerakia::FileParseError, "While parsing #{diskname}: #{e.message}"
      end
    end

    def run
      #
      # Do the lookup

      Jerakia.log.debug("Searching key #{lookup.request.key} from file format #{options[:format]} (#{whoami})")
      option :searchpath, :type => Array,  :mandatory => true
      option :format,     :type => Symbol, :default => :yaml
      option :docroot,    :type => String, :default => '/etc/jerakia/data'
      option :extension,  :type => String

      load_format_handler

      options[:searchpath].flatten.each do |path|
        Jerakia.log.debug("Attempting to load data from #{path}")
        return unless response.want?
        data = read_from_file(path)
        Jerakia.log.debug("Datasource provided #{data} looking for key #{lookup.request.key}")
        unless data[lookup.request.key].nil?
          Jerakia.log.debug("Found data #{data[lookup.request.key]}")
          response.submit data[lookup.request.key]
        end
      end
    end
  end
end
