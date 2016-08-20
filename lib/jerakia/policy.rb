require 'jerakia/launcher'
require 'jerakia/answer'
require 'jerakia/schema'

class Jerakia::Policy 

  attr_accessor :lookups
  attr_reader   :answer
  attr_reader   :scope
  attr_reader   :lookup_proceed
  attr_reader   :schema
  attr_reader   :request

  def initialize(name, opts={}, req)

    if req.use_schema and Jerakia.config[:enable_schema]
      schema_config = Jerakia.config[:schema] || {}
      @schema = Jerakia::Schema.new(req, schema_config)
    end


    @lookups=[]
    @routes={}
    @request=req
    @answer=Jerakia::Answer.new(req.lookup_type)
    @scope=Jerakia::Scope.new(req)
    @lookup_proceed = true    
  end

  def clone_request
    copy_request = request.clone
    return copy_request
  end

  def submit_lookup(lookup)
    raise Jerakia::PolicyError, "Lookup #{lookup.name} has no datasource defined" unless lookup.get_datasource
    @lookups << lookup if lookup.valid? and @lookup_proceed
    @lookup_proceed = false if !lookup.proceed? and lookup.valid?
  end

  def fire!
    response_entries = []

    @lookups.each do |l|
      responses = l.run
      response_entries = responses.entries.map { |r| r }
    end

    response_entries.each do |res|
      case request.lookup_type
      when :first
          @answer.payload ||= res[:value]
          @answer.datatype ||= res[:datatype]
      when :cascade
          @answer.payload << res[:value]
      end
    end

    if request.lookup_type == :cascade && @answer.payload.is_a?(Array)
      case request.merge
      when :array
        @answer.flatten_payload!
      when :hash,:deep_hash
        @answer.merge_payload!(request.merge)
      end
    end

  end
end

