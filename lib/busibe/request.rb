module Busibe
  module Request
    def get(path, params = {})
      perform_request(
        :get,
        path,
        params,
        public_key: @public_key, access_token: @access_token
      )
    end

    def post(path, params = {})
      perform_request(
        :post,
        path,
        params,
        public_key: @public_key, access_token: @access_token
      )
    end

    private

    def perform_request(method, path, params, options)
      @connection = connection(options)
      @response = @connection.run_request(
        method,
        path,
        params,
        nil
      ) do |request|
        request.options[:raw] = true if options[:raw]

        case method.to_sym
        when :get
          request.url(path, params)
        when :post
          request.path = path
          request.body = params unless params.empty?
        end
      end

      options[:raw] ? @response : @response.body
    end
  end
end
