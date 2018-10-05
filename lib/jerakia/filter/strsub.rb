class Jerakia
  class Filter
    class Strsub < Jerakia::Filter
      def filter
        all_keys do |key|
          key.parse_values do |val|
            do_substr(val) if val.is_a?(String)
          end
        end
      end

      def do_substr(data)
        maps = options
        data.gsub!(/%\{([^\}]*)\}/) do |tag|
          Jerakia.log.debug("matched substr #{tag}")
          scopekey = tag.match(/\{([^\}]+)\}/)[1]
          scopekey.gsub!(/^::/, '')
          maps[scopekey.to_sym]
        end
      end
    end
  end
end

