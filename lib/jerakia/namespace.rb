require 'jerakia'
require 'jerakia/log'

class Jerakia
  class Namespace
    attr_reader :name
    attr_reader :keys

    def initialize(name)
      @name = name
    end
  end
end

    
