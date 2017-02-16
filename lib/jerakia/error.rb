class Jerakia
  class Error < RuntimeError
    def initialize(msg)
      super(msg)
    end
  end

  class PolicyError < Jerakia::Error
  end

  class SchemaError < Jerakia::Error
  end

  class FileParseError < Jerakia::Error
  end

  class ScopeError < Jerakia::Error
  end
end
