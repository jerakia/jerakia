class Jerakia
  module Util
    class << self
      def autoload(path, mod)
        Jerakia.log.debug "autoloading #{path} #{mod}"
        require "jerakia/#{path}/#{mod}"
      end

      def dig(data, dig_path)
        key = dig_path.shift
        if dig_path.empty?
          if data.has_key?(key)
            return data[key]
          else
            return :not_found
          end
        else
          return :not_found unless data[key].is_a?(Hash)
          return dig(data[key], dig_path)
        end
      end

      def walk(data)
        if data.is_a?(Hash)
          walk_hash(data) do |target|
            yield target
          end
        elsif data.is_a?(Array)
          walk_array(data) do |target|
            yield target
          end
        else
          yield data
        end
      end

      def walk_hash(data)
        data.each_with_object({}) do |(_k, v), h|
          if v.is_a?(Hash)
            walk_hash(v) { |x| yield x }
          elsif v.is_a?(Array)
            walk_array(v) { |x| yield x }
          else
            yield v
          end
          h
        end
        data
      end

      def walk_array(data)
        data.map! do |element|
          if element.is_a?(Hash)
            walk_hash(element) { |x| yield x }
          elsif element.is_a?(Array)
            walk_array(element) { |x| yield x }
          else
            yield element
          end
          element
        end
      end
    end
  end
end
