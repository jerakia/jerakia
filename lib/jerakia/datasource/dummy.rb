class Jerakia::Datasource
  module Dummy

    def run
      #
      # Do the lookup

      Jerakia.log.debug("Searching key #{lookup.request.key} in dummy datasource")
      option :return, { :type => [ String, Hash, Array ], :default => "Returned data" }  
      response.submit options[:return]
      

      
    end
  end
end

