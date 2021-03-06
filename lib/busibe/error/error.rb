module Busibe
  module Error
    class Error < StandardError
      attr_reader :http_headers

      def initialize(message, http_headers)
        @http_headers = http_headers
        super(message)
      end
    end # Error
  end

  module Error
    class ServerError < Busibe::Error::Error; end
  end

  module Error
    class ServiceUnavailable < Busibe::Error::ServerError; end
  end

  module Error
    class ClientError < Busibe::Error::Error; end
  end

  module Error
    class Forbidden < Busibe::Error::ClientError; end
  end

  module Error
    class BadRequest < Busibe::Error::ClientError; end
  end

  module Error
    class RequestTooLarge < Busibe::Error::ClientError; end
  end
end
