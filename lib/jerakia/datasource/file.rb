require 'jerakia/cache/file'

#Jerakia::Datasource.define(:file) do
#
class Jerakia::Datasource::File < Jerakia::Datasource::Instance

  option(:searchpath, :required => true) { |opt| opt.is_a?(Array) }

  option :format,  :default => :yaml
  option :docroot, :default => '/var/lib/jerakia/data'
  option :extension
  option :enable_caching, :default => true

  def load_format_handler
    format = options[:format]
    require "jerakia/datasource/file/#{format.to_s}"
    eval "extend Jerakia::Datasource::File::#{format.to_s.capitalize}"
  end

  def format_handler
    format = options[:format]
    eval "Jerakia::Datasource::File::#{format.to_s.capitalize}"
  end

  def extension
    options[:extension] || format_handler::EXTENSION
  end

  def cache
    Jerakia::Cache::File
  end

  def get_file_with_cache(diskname)
    Jerakia.log.debug("Querying cache for file #{diskname}")
    cache.retrieve(diskname)
  end

  def get_file(diskname)
    ::File.read(diskname) if ::File.exists?(diskname)
  end

  def list_fragments(prefix, extension)
    Dir["#{prefix}.d/*.#{extension}"] if ::File.directory?("#{prefix}.d")
  end

  def read_from_file(fname)
    docroot = options[:docroot]
    namespace = request.namespace
    cached = options[:enable_caching]
    
    fpath = []
    fpath << docroot unless fname[0] == '/'
    fpath << [fname, namespace]

    diskname_prefix = ::File.join(fpath.flatten).gsub(/\/$/, '').to_s
    diskname = "#{diskname_prefix}.#{extension}"

    files = [diskname]
    files << list_fragments(diskname_prefix, extension)

    raw_data = ''

    files.flatten.compact.each do |f|
      Jerakia.log.debug("read_from_file()  #{f}")
      file_contents = get_file_with_cache(f)
      if cached
        file_contents = get_file_with_cache(f)
      else
        file_content = get_file(f)
      end
      raw_data << file_contents if file_contents
    end

    begin
      convert(raw_data)
    rescue Jerakia::FileParseError => e
      raise Jerakia::FileParseError, "While parsing #{diskname}: #{e.message}"
    end
  end

  def lookup
    Jerakia.log.debug("Searching key #{request.key} from file format #{options[:format]}")

    load_format_handler
    paths=options[:searchpath].flatten

    answer do |response|
      path = paths.shift
      break unless path
      data = read_from_file(path)
      if data.has_key?(request.key)
        response.submit data[request.key]
      end
    end
  end
end
