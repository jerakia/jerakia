require 'jerakia/cache'

class Jerakia::Cache::File
  class << self
    def cache
      Jerakia::Cache
    end

    # Returns the latest mtime of the file if the file exists and
    # nil if it doesn't exist.
    #
    def state(filename)
      ::File.stat(filename).mtime if ::File.exist?(filename)
    end

    def add(index, data)
      filestate = state(index)
      Jerakia.log.debug("Adding #{index} to file cache with state #{filestate}")
      cache.add(index, data, :state => filestate) if filestate
    end

    def valid?(index)
      if cache.in_bucket?(index)
        unless File.exist?(index)
          cache.purge(index)
          return false
        end
        metadata = cache.metadata(index)
        if metadata
          metadata[:state] == state(index)
        else
          false
        end
      else
        false
      end
    end

    def import_file(filename)
      Jerakia.log.debug("Importing file #{filename} to file cache")
      File.read(filename)
    end

    # If the cache has a valid copy of the file, then we retrieve it, if the cache
    # doesn't have a copy, or if the state has changed, then we should add it to
    # the cache again and overite the existing data.
    #
    # Returns nil if the file doesn't exist
    #
    def retrieve(filename)
      if valid?(filename)
        Jerakia.log.debug("Using cached contents of #{filename}")
        get(filename)
      else
        add(filename, import_file(filename)) if File.exist?(filename)
      end
    end

    def get(index)
      cache.get(index)
    end
  end
end
