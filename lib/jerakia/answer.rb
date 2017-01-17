class Jerakia
  class Answer
    require 'deep_merge'

    attr_accessor :payload
    attr_accessor :datatype
    attr_reader :lookup_type

    def initialize(lookup_type = :first)
      case lookup_type
      when :first
        @payload = nil
      when :cascade
        @payload = []
        @datatype = 'array'
      end
    end

    def flatten_payload!
      @payload.flatten!
    end

    # TODO: consolidate this into less lines
    #
    def merge_payload!(method = :hash) # rubocop:disable Metrics/MethodLength
      payload_hash = {}
      @payload.each do |p|
        next unless p.is_a?(Hash)
        case method
        when :hash
          payload_hash = p.merge(payload_hash)
        when :deep_hash
          payload_hash = p.deep_merge!(payload_hash)
        end
      end
      @payload = payload_hash
      set_data_type
    end

    def set_data_type
      @data_type = @payload.class.to_s.downcase
    end
  end
end
