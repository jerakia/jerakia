class Jacaranda::Datasource
  module Dummy

    def run
      #
      # Do the lookup

      Jacaranda.log.debug("Searching key #{lookup.request.key} in dummy datasource")
      option :return,    String, 'returned data'
      response.submit options[:return]
      

      
    end
  end
end

