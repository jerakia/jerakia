class Jerakia
  class Answer
    require 'deep_merge'

    attr_accessor :payload
    attr_accessor :datatype
    attr_reader :merge_strategy
    attr_reader :lookup_type

    def initialize(lookup_type = :first, merge_strategy = :array)
      @lookup_type = lookup_type
      @merge_strategy = merge_strategy
      @found = false
      case lookup_type
      when :first
        @payload = nil
      when :cascade
        @payload = []
        @datatype = 'array'
      end
    end

    def process_response(response_entries)
      responses = response_entries.flatten.compact

      return nil if responses.empty?
      @found = true

      responses.each do |res|
        case lookup_type
        when :first
          @payload = res[:value]
          @datatype = res[:datatype]
          Jerakia.log.debug("Registered answer as #{payload}")
          break
        when :cascade
          @payload << res[:value]
        end
      end
      consolidate
    end

    def found?
      @found
    end

    def consolidate
      if lookup_type == :cascade && payload.is_a?(Array)
        case merge_strategy
        when :array
          flatten_payload!
        when :hash, :deep_hash
          merge_payload!
        end
      end
    end


    def flatten_payload!
      @payload.flatten!
    end

    # TODO: consolidate this into less lines
    #
    def merge_payload! # rubocop:disable Metrics/MethodLength
      payload_hash = {}
      @payload.each do |p|
        next unless p.is_a?(Hash)
        case merge_strategy
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
