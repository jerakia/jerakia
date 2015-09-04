class Jerakia::Answer

  attr_accessor :payload
  attr_accessor :datatype
  attr_reader :lookup_type

  def initialize(lookup_type = :first)
    case lookup_type
    when :first
      @payload=nil
    when :cascade
      @payload=[]
      @datatype="array"
    end
  end

  def flatten_payload!
    @payload.flatten!
  end

  def merge_payload!
    payload_hash={}
    @payload.each do |p|
      if p.is_a?(Hash)
        payload_hash.merge!(p)
      end
    end
    @payload=payload_hash
    set_data_type
  end

  def set_data_type
    @data_type=@payload.class.to_s.downcase
  end
end

