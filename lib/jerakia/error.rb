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

  class DatasourceArgumentError < Jerakia::Error
  end

  class HTTPError < Jerakia::Error
  end

  class EncryptionError < Jerakia::Error
  end

end
