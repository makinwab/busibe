require "faraday"
require "error/client_error"
require "error/server_error"

module Busibe
  module Connection
    private
      def connection
        default_options = {
          url: options.fetch(:endpoint, endpoint)
        }

        @connection ||= Faraday.new(default_options) do |faraday|
          faraday.use Busibe::Error::ClientError
          faraday.use Busibe::Error::ServerError
          faraday.request :url_encoded
          faraday.response :logger
          faraday.adapter adapter #Faraday.default_adapter
        end
      end
  end
end