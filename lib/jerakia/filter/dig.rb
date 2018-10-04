class Jerakia
  class Filter
    class Dig < Jerakia::Filter

      def filter
        path = options || []
        all_keys do |key|
          unless key.value.is_a?(Hash)
            raise Jerakia::Error, "Cannot dig on key #{key.name}, has type of  #{key.value.class}."
          end

          newval = Jerakia::Util.dig(key.value, path.flatten)
          if newval == :not_found
            Jerakia.log.debug("[filter:dig]: Key #{key.name} invalid, dig returned nil")
            dataset.namespace(key.namespace.name).delete_key(key.name)
          else
            key.set(newval)
          end
            
        end
      end
    end
  end
end
