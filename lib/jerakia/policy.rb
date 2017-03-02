require 'jerakia/launcher'
require 'jerakia/answer'
require 'jerakia/schema'

class Jerakia
  class Policy
    attr_accessor :lookups
    attr_reader   :answer
    attr_reader   :schema

    attr_reader   :name

    # _opts currently does not get used, but is included here as a placeholder
    # for allowing policies to be declared with options;
    # policy :foo, :option => :value do
    #
    def initialize(name, _opts)
      @name = name
      @lookups = []
    end

    def run(request)

      if request.use_schema && Jerakia.config[:enable_schema]
        schema_config = Jerakia.config[:schema] || {}
        @schema = Jerakia::Schema.new(request, schema_config)
      end

      scope = Jerakia::Scope.new(request)
      answer = Jerakia::Answer.new(request.lookup_type, request.merge)

      response_entries = []
      lookups.each do |lookup|
        lookup_instance = lookup.call clone_request(request), scope
        next unless lookup_instance.valid? && lookup_instance.proceed?
        responses = lookup_instance.run
        lookup_answers = responses.entries.map { |r| r}
        response_entries << lookup_answers if lookup_answers
      end
      answer.process_response(response_entries)
      return answer
    end

    def clone_request(request)
      Marshal.load(Marshal.dump(request))
    end

  end
end
