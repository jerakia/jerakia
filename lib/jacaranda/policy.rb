require 'jacaranda/launcher'

class Jacaranda::Policy < Jacaranda
  require 'jacaranda/answer'

  attr_accessor :lookups
  attr_reader   :routes
  attr_reader   :answer
  attr_reader   :scope

  def initialize(&block)
    @lookups=[]
    @routes={}
    @answer=Jacaranda::Answer.new(request.lookup_type)
    @scope=Jacaranda::Scope.new
    instance_eval &block
  end

  def clone_request
    Marshal.load(Marshal.dump(request))
  end

  def lookup(name,&block)
    # We specifically clone the request object to allow plugins to modify the
    # request payload for the scope of this lookup only.
    #
    lookup = Jacaranda::Lookup.new(clone_request,scope,&block)
   
    @lookups << lookup if lookup.valid?
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

