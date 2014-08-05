class Jacaranda::Response < Jacaranda

  attr_accessor :entries
  attr_reader :lookup

  def initialize(lookup)
    @entries=[]
    @lookup=lookup
    require 'jacaranda/response/filter'
    extend Jacaranda::Response::Filter
  end

  def want?
    if lookup.request.lookup_type == :first && entries.length > 0
      return false
    else
      return true
    end
  end

  def submit(val)
    Jacaranda::Log.debug "Backend submitted #{val}"
    unless want?
      no_more_answers
    else
      @entries << {
        :value => val,
        :datatype => val.class.to_s.downcase
      }
      Jacaranda::Log.debug "Added answer #{val}"
    end
  end

  def values
    Jacaranda::Util.walk(@entries) do |entry|
      yield entry
    end
  end

  def parse_values
    @entries.map! do |entry|
      Jacaranda::Util.walk(entry[:value]) do |v|
        yield v
      end
      puts "***"
      p entry
      puts "***"
      entry
    end

  end
      


  def no_more_answers
    Jacaranda::Log.debug "warning: backend tried to submit too many answers"
  end

end

