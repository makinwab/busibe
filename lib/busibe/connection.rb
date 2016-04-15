require "faraday"
require "faraday_middleware"
require "busibe/error/raise_client_error"
require "busibe/error/raise_server_error"

module Busibe
  module Connection
    private

      def connection(options)
        default_options = {
          url: options.fetch(:endpoint, endpoint)
        }

        @connection ||= Faraday.new(default_options) do |faraday|
          faraday.use(
            Faraday::Request::BasicAuthentication,
            options[:public_key],
            options[:access_token]
          )

          faraday.use Busibe::Error::RaiseClientError
          faraday.use Busibe::Error::RaiseServerError
          faraday.request :url_encoded
          faraday.adapter Faraday.default_adapter
        end
      end
  end
end
