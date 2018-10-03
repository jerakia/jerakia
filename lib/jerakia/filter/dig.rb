class Jerakia
  class Filter
    class Dig < Jerakia::Filter

      def filter
        all_keys { |key| key.set('bar') }
      end
    end
  end
end
