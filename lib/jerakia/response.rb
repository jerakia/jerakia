class Jerakia::Response < Jerakia
  attr_accessor :entries
  attr_reader :lookup

  def initialize(lookup)
    @entries = []
    @lookup = lookup
    require 'jerakia/response/filter'
    extend Jerakia::Response::Filter
  end

  def want?
    if lookup.request.lookup_type == :first && !entries.empty?
      return false
    else
      return true
    end
  end

  def submit(val)
    Jerakia.log.debug "Backend submitted #{val}"
    if want?
      @entries << {
        :value => val,
        :datatype => val.class.to_s.downcase
      }
      Jerakia.log.debug "Added answer #{val}"
    else
      no_more_answers
    end
  end

  def values
    Jerakia::Util.walk(@entries) do |entry|
      yield entry
    end
  end

  def parse_values
    @entries.map! do |entry|
      Jerakia::Util.walk(entry[:value]) do |v|
        yield v
      end
      entry
    end
  end

  def no_more_answers
    Jerakia.log.debug 'warning: backend tried to submit too many answers'
  end
end
