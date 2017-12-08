class Jerakia::Response < Jerakia
  attr_reader :lookup

  class Entry
    attr_reader :value
    attr_reader :datatype
    attr_reader :valid

    def initialize(val)
      @valid = true
      set_value(val)
    end

    def invalidate
      @valid = false
    end

    def valid?
      @valid
    end

    def set_value(val)
      @value = val
      @datatype = val.class.to_s.downcase
    end
  end

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
      @entries << Jerakia::Response::Entry.new(val)
      Jerakia.log.debug "Added answer #{val}"
    else
      no_more_answers
    end
  end

  def responses
    @entries.each do |entry|
      yield entry
    end
  end

  def entries
    @entries.select { |e| e.valid? }
  end

  def parse_values
    @entries.map! do |entry|
      Jerakia::Util.walk(entry.value) do |v|
        yield v
      end
      entry
    end
  end

  def no_more_answers
    Jerakia.log.debug 'warning: backend tried to submit too many answers'
  end
end
