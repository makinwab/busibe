require "faraday"
require "busibe/error/client_error"
require "busibe/error/server_error"

module Busibe
  module Connection
    private

      def connection(options)
        default_options = {
          url: options.fetch(:endpoint, endpoint)
        }

        @connection ||= Faraday.new(default_options) do |faraday|
          faraday.use Busibe::Error::ClientError
          faraday.use Busibe::Error::ServerError
          faraday.request :url_encoded
          faraday.response :logger
          faraday.adapter Faraday.default_adapter
        end
      end
  end
end
