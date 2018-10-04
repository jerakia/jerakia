class Jerakia
  class Filter
    class Keyregsub

      def filter
        regex, replace = options
        Jerakia::Error, "First argument to keyregsub must be a Regexp" unless regex.is_a?(Regexp)
      end
    end
  end
end
