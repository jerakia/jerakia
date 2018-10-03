require 'deep_merge'

class Jerakia
  class Dataset
    class Key
      attr_reader :name
      attr_reader :value
      attr_reader :cascade
      attr_reader :merge
      attr_reader :namespace
 


      def initialize(namespace, name)
        @name = name
        @namespace = namespace
        @value = nil
        set_attributes
      end

      def set_attributes
        @merge = namespace.request.merge
        if namespace.request.lookup_type == :first
          @cascade = false
        else
          @cascade = true
        end
        load_from_schema if namespace.request.use_schema
      end

      def load_from_schema
        schema_config = Jerakia.config[:schema] || {}
        schema = Jerakia::Schema.new({:name => @name, :namespace => @namespace.name}, schema_config)
        @merge = schema.merge unless schema.merge.nil?
        @cascade = schema.cascade unless schema.cascade.nil?
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
        if has_value?
          if cascade?
            Jerakia.log.debug("Adding #{value}")
            add_to_value(value)
          else
            Jerakia.log.debug("Rejecting #{value}")
          end
        else
          set(value)
        end
      end 

      private

      def add_to_value(newval)
        case @merge
        when :array
          @value << newval
          @value.flatten!
        when :hash
          newhash = @value.merge(newval)
          @value = newhash
        when :deep_hash
          newhash = @value.deep_merge!(newval)
          @value = newhash
        end
      end

    end
  end
end
      

      
