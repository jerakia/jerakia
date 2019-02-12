require 'jerakia/cache/file'

#Jerakia::Datasource.define(:file) do
#
class Jerakia::Datasource::File < Jerakia::Datasource::Instance

  option(:searchpath, :required => true) { |opt| opt.is_a?(Array) }

  option :format,  :default => :yaml
  option :docroot, :default => '/var/lib/jerakia/data'
  option :extension
  option :enable_caching, :default => true
  option :map_namespace, :default => true

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
    Dir["#{prefix}.d/*.#{extension}"].sort if ::File.directory?("#{prefix}.d")
  end


  def namespaces
    return [request.namespace] unless request.namespace.empty?
    found_namespaces = []
    options[:searchpath].flatten.each do |path|
      found_namespaces << query_namespaces(path)
    end
    found_namespaces.flatten.uniq
  end

  def query_namespaces(base)
    rootdir = File.join(options[:docroot], base)
    Dir[File.join(rootdir, '*.yaml')].map { |m| File.basename(m, ".#{extension}") }
  end

  def read_from_file(fname,namespace = request.namespace)
    docroot = options[:docroot]
    enable_caching = options[:enable_caching]

    fpath = []
    fpath << docroot unless fname[0] == '/'
    fpath << fname
    fpath << namespace if options[:map_namespace]

    diskname_prefix = ::File.join(fpath.flatten).gsub(/\/$/, '').to_s
    diskname = "#{diskname_prefix}.#{extension}"

    files = [diskname]
    files << list_fragments(diskname_prefix, extension)

    raw_data = ''

    files.flatten.compact.each do |f|
      Jerakia.log.debug("read_from_file()  #{f}")
      if enable_caching
        file_contents = get_file_with_cache(f)
      else
        file_contents = get_file(f)
      end
      raw_data << file_contents if file_contents
    end

    begin
      struct_data = convert(raw_data)
      return struct_data.nil? ? {} : struct_data
    rescue Jerakia::FileParseError => e
      raise Jerakia::FileParseError, "While parsing #{diskname}: #{e.message}"
    end
  end

  def lookup
    load_format_handler
    paths = options[:searchpath].flatten
    reply do |response|
      paths.each do |path|
        #namespaces.each do |namespace|
          data = read_from_file(path, request.namespace)
          unless data.empty?
            response.namespace(request.namespace).submit data
          end
        #end
      end
    end
  end
end
