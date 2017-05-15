require 'jerakia/launcher'
require 'jerakia/answer'
require 'jerakia/schema'
require 'msgpack'

class Jerakia
  class Policy
    attr_accessor :lookups
    attr_reader   :answer
    attr_reader   :scope
    attr_reader   :lookup_proceed
    attr_reader   :schema
    attr_reader   :request

    # _opts currently does not get used, but is included here as a placeholder
    # for allowing policies to be declared with options;
    # policy :foo, :option => :value do
    #
    def initialize(_name, _opts, req)
      if req.use_schema && Jerakia.config[:enable_schema]
        schema_config = Jerakia.config[:schema] || {}
        @schema = Jerakia::Schema.new(req, schema_config)
      end

      @lookups = []
      @request = req
      @answer = Jerakia::Answer.new(req.lookup_type)
      @scope = Jerakia::Scope.new(req)
      @lookup_proceed = true
    end

    def clone_request
      #Marshal.load(Marshal.dump(request))
      MessagePack.unpack(request.to_msgpack)
    end

    def submit_lookup(lookup)
      raise Jerakia::PolicyError, "Lookup #{lookup.name} has no datasource defined" unless lookup.get_datasource
      @lookups << lookup if lookup.valid? && @lookup_proceed
      @lookup_proceed = false if !lookup.proceed? && lookup.valid?
    end

    def execute
      response_entries = []

      @lookups.each do |l|
        responses = l.run
        lookup_answers = responses.entries.map { |r| r }
        response_entries << lookup_answers if lookup_answers
      end

      response_entries.flatten.each { |res| process_response(res) }
      consolidate_answer
    end

    private

    # Process the response depending on the requests lookup_type
    # if it is a :first lookup then we only want to set the result
    # once, if it's cascading, we should ammend the payload array
    #
    def process_response(res)
      case request.lookup_type
      when :first
        @answer.payload ||= res[:value]
        @answer.datatype ||= res[:datatype]
      when :cascade
        @answer.payload << res[:value]
      end
    end

    # Once all the responses are submitted into the answers payload
    # we need to consolidate the data based on the merge behaviour
    # requested.
    #
    def consolidate_answer
      if request.lookup_type == :cascade && @answer.payload.is_a?(Array)
        case request.merge
        when :array
          @answer.flatten_payload!
        when :hash, :deep_hash
          @answer.merge_payload!(request.merge)
        end
      end
    end
  end
end
