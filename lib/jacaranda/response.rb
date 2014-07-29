class Jacaranda::Response

  attr_accessor :entries
  attr_reader :lookup

  def initialize(lookup)
    @entries=[]
    @lookup=lookup
    require 'jacaranda/response/filter'
    extend Jacaranda::Response::Filter
  end

  def submit(val)
    Jacaranda::Log.debug "Backend submitted #{val}"
    if lookup.request.lookup_type == :first && entries.length > 0
      no_more_answers
    else
      @entries << {
        :value => val,
        :datatype => val.class.to_s.downcase
      }
    end
  end

  def no_more_answers
    Jacaranda::Log.debug "warning: backend tried to submit too many answers"
  end

end

