class Jerakia::Response
  module Filter
    module Dig
      def filter_dig(path = [])
        raise Jerakia::PolicyError, "Argument to output filter dig must be an array" unless path.is_a?(Array)
        Jerakia.log.debug("[output_filter:dig]: Attempting to dig using path #{path}")
        responses do |entry|

          unless entry.value.is_a?(Hash)
            raise Jerakia::Error, "Cannot perform dig on a non hash value"
          end

          value = Jerakia::Util.dig(entry.value, path.flatten)
          if value == :not_found
            Jerakia.log.debug('[output_filter:dig]: Digging value from response failed, invalidating')
            entry.invalidate
          else
            entry.set_value(value)
            Jerakia.log.debug("[output_filter:dig]: Re-submitting response as #{value}")
          end
        end
      end
    end
  end
end
