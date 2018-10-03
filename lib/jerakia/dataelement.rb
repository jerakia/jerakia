require 'jerakia'
require 'jerakia/log'

class Jerakia
  class DataElement
    attr_reader :key
    attr_reader :namespace
    attr_reader :merge
    attr_reader :cascade
    attr_accessor :values

    def initialize(opts = {})
      @key = opts[:key]
      @namespace = opts[:namespace]
      @cascade = false
      @merge = :none
      Jerakia.log.debug("New DataElement created for #{@key} in #{@namespace}")
    end

    def cascade?
      @cascade
    end

    def submit(val)
      @values << val
    end

    def values
      @values
    end

  
    def load_schema
    end

  end
end

      
