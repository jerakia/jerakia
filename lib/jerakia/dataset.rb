require 'jerakia'
require 'jerakia/log'
require 'jerakia/dataset/namespace'
require 'jerakia/dataset/key'

class Jerakia
  class Dataset

    attr_reader :namespaces
    attr_reader :request
    attr_reader :use_schema

    def initialize(request)
      @namespaces={}
      @request = request
      self.namespace(request.namespace)
    end


    def submit(options)
      namespace(options[:namespace])
      data = options[:data]
    end

    def namespace(name)
      arrname = Array(name)
      @namespaces[arrname] ||= Jerakia::Dataset::Namespace.new(arrname, @request)
      @namespaces[arrname]
    end

    def has_namespace?(name)
      arrname = Array(name)
      @namespaces.has_key?(arrname)
    end

    def empty?
      @namespaces.empty?
    end
  end
end
