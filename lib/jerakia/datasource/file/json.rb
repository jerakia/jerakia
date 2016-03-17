class Jerakia::Datasource
  module File
    class Json

      EXTENSION='json'

      class << self
        require 'json'
        def convert(data)
          return {} if data.empty?
          JSON.load(data)
        end
      end
    end
  end
end

