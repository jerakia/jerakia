require 'jacaranda/launcher'

class Jacaranda::Policy < Jacaranda::Launcher
  require 'jacaranda/answer'

  attr_accessor :lookups
  attr_reader   :routes
  attr_reader   :answer
  attr_reader   :scope
  attr_reader   :lookup_proceed

  def initialize(name, opts, &block)
    @lookups=[]
    @routes={}
    @answer=Jacaranda::Answer.new(request.lookup_type)
    @scope=Jacaranda::Scope.new
    @lookup_proceed = true    
    begin
      instance_eval &block
    rescue => e
      Jacaranda.fatal "Error processing policy file", e
    end
  end

  def clone_request
    Marshal.load(Marshal.dump(request))
  end


  def lookup(name,opts={},&block)
    # We specifically clone the request object to allow plugins to modify the
    # request payload for the scope of this lookup only.
    #
    lookup = Jacaranda::Lookup.new(name,clone_request,scope,&block)
    Jacaranda.log.debug("Proceed to next lookup #{lookup.proceed?}")
   
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

      if request.lookup_type == :cascade && @answer.payload.is_a?(Array) && request.merge == :array
        @answer.flatten_payload!
      end
      if request.lookup_type == :cascade && @answer.payload.is_a?(Array) && request.merge == :hash
        @answer.merge_payload!
      end

    end
  end
end

