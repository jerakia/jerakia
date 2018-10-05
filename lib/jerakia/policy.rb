require 'jerakia/launcher'
require 'jerakia/answer'
require 'jerakia/schema'
require 'jerakia/datasource'

class Jerakia
  class Policy
    attr_accessor :lookups
    attr_reader   :name
    attr_reader   :datasources

    # _opts currently does not get used, but is included here as a placeholder
    # for allowing policies to be declared with options;
    # policy :foo, :option => :value do
    #
    def initialize(name, _opts)
      @name = name
      @lookups = []
      @datasources = {}
    end

    def run(request)

      scope = Jerakia::Scope.new(request)
      dataset = Jerakia::Dataset.new(request)
      response_entries = []

      lookups.each do |lookup|
        lookup_instance = lookup.call clone_request(request), scope
        next unless lookup_instance.valid?

        register_datasource lookup_instance.datasource[:name]
        responses = Jerakia::Datasource.run(dataset, lookup_instance)
        lookup_instance.output_filters.each do |filter|
          Jerakia.log.debug("Using output filter #{filter[:name]}")
          Jerakia::Filter.load(filter[:name], dataset, filter[:opts]).filter
        end
        break unless lookup_instance.proceed?
      end
      answer = Jerakia::Answer.new(request,dataset)
      Jerakia.log.debug(answer)
      return answer
    end

    def register_datasource(datasource)
      Jerakia::Datasource.load_datasource(datasource)
    end

    def clone_request(request)
      Marshal.load(Marshal.dump(request))
    end

  end
end
