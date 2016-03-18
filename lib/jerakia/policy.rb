require 'jerakia/launcher'

class Jerakia::Policy 
  require 'jerakia/answer'
  require 'jerakia/schema'

  attr_accessor :lookups
  attr_reader   :routes
  attr_reader   :answer
  attr_reader   :scope
  attr_reader   :lookup_proceed
  attr_reader   :schema

  def initialize(name, opts={}, req, &block)

    if req.use_schema and Jerakia.config[:enable_schema]
      schema_config = Jerakia.config[:schema] || {}
      @schema = Jerakia::Schema.new(req, schema_config)
    end
    p req
    @lookups=[]
    @routes={}
    @request=req
    @answer=Jerakia::Answer.new(req.lookup_type)
    @scope=Jerakia::Scope.new(req)
    @lookup_proceed = true    
    begin
      instance_eval &block
    rescue => e
      Jerakia.fatal "Error processing policy file", e
    end
  end


  def request
    @request
  end

  def clone_request
    Marshal.load(Marshal.dump(request))
  end


  def lookup(name,opts={},&block)
    # We specifically clone the request object to allow plugins to modify the
    # request payload for the scope of this lookup only.
    #
    lookup = Jerakia::Lookup.new(name,opts,clone_request,scope,&block)
    Jerakia.log.debug("Proceed to next lookup #{lookup.proceed?}")
   
    @lookups << lookup if lookup.valid? and @lookup_proceed
    @lookup_proceed = false if !lookup.proceed? and lookup.valid?

  end

  def fire!
    @lookups.each do |l|
      responses = l.run
      responses.entries.each do |res|
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
end

