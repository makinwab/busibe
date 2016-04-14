require "faraday"
require "busibe/error/error"

module Busibe
  module Error
    class ServerError < Faraday::Response::Middleware
      def on_complete(env)
        status  = env[:status].to_i
        headers = env[:response_headers]

        case status
        when 503
          message = "503 No server is available to handle this request."
          raise Busibe::Error::ServiceUnavailable.new message, headers
        end
      end
    end
  end
end
