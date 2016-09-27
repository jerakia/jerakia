# strsub is in output filter that matches tags in data and replaces them
# for values in the scope.  It mimics the hiera features of being able to
# embed %{::var} in YAML documents.  This output filter may not provide
# 100% compatibility to hiera but it should cover most scenarios.
#
# Jerakia does not support method or literal interpolations, just straightforward %{var} and %{::var}
#
# ::var will be lookuped up as scope[:var]

class Jerakia::Response
  module Filter
    module Strsub
      def filter_strsub(_opts = {})
        parse_values do |val|
          do_substr(val) if val.is_a?(String)
          val
        end
      end

      def do_substr(data)
        data.gsub!(/%\{([^\}]*)\}/) do |tag|
          Jerakia.log.debug("matched substr #{tag}")
          scopekey = tag.match(/\{([^\}]+)\}/)[1]
          scopekey.gsub!(/^::/, '')
          lookup.scope[scopekey.to_sym]
        end
      end
    end
  end
end
