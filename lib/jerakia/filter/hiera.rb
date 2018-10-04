# This is a filter used internally by the hiera lookup plugin to
# modify the request object to reset the key

class Jerakia
  class Filter
    class Hiera < Jerakia::Filter

      def filter
        key = options[:key]
        
      require 'pry'; binding.pry
      end
    end
  end
end 
