require 'deep_merge'

class Jerakia
  class Dataset
    class Key
      attr_reader :name
      attr_reader :value
      attr_reader :cascade
      attr_reader :merge
      attr_reader :namespace
      attr_reader :valid
 


      def initialize(namespace, name)
        @name = name
        @namespace = namespace
        @value = nil
        @valid = true
        set_attributes
      end

      def set_attributes
        @merge = namespace.request.merge
        if namespace.request.lookup_type == :first
          @cascade = false
        else
          @cascade = true
        end
        load_from_schema if namespace.request.use_schema?
      end

      def load_from_schema
        if namespace.request.schema.has_key?(name)
          schema = namespace.request.schema.key(name)
          @merge = schema.merge unless schema.merge.nil?
          @cascade = schema.cascade unless schema.cascade.nil?
        end
      end

      def has_value?
        ! @value.nil?
      end

      def cascade?
        @cascade
      end
  
      def set(value)
        @value = value
      end

      def ammend(value)
        if cascade?
          add_to_value(value)
        else
          if has_value?
            Jerakia.log.debug("Rejecting #{value}")
          else
            Jerakia.log.debug("Adding #{value}")
            set(value)
          end
        end
      end 

      def invalidate!
        @valid = false
      end

      def validate!
        @valid = true
      end

      def valid?
        @valid
      end

      def parse_values
        Jerakia::Util.walk(value) do |v|
          yield v
        end
      end

      private

      def add_to_value(newval)
        case @merge
        when :array
          @value ||= []
          @value << newval
          @value.flatten!
        when :hash
          @value ||= {}
          newhash = newval.merge(@value)
          @value = newhash
        when :deep_hash
          @value ||= {}
          newhash = newval.deep_merge!(@value)
          @value = newhash
        end
      end

    end
  end
end
      

      
