class Jerakia
  class Error < RuntimeError

    def initialize(msg)
      super(msg)
    end

  end

  

  class PolicyError < Jerakia::Error
  end
end

