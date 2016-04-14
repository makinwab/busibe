require "faraday"

module Busibe
  module Error
    class ClientError < Faraday::Response::Middleware
      def on_complete(env)
        status  = env[:status].to_i
        body    = env[:body]
        headers = env[:response_headers]

        case status
        when 400
          raise Busibe::Error::BadRequest.new body, headers
        when 403
          raise Busibe::Error::Forbidden.new body, headers
        when 413
          raise Busibe::Error::RequestTooLarge.new body, headers
        end
      end
    end # ClientError
  end
end
