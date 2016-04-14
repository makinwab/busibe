module Busibe
  module Request
    def get(path, params = {}, options = {})
      perform_request(:get, path, params, options)
    end

    def post(path, params = {}, options = {})
      perform_request(:post, path, params, options)
    end

    private

    def perform_request(method, path, params, options)
      @connection ||= connection(options)
      @response = case method
                  when :get
                    @connection.get(path)
                  when :post
                    @connection.post(path, params)
                  end
    end
  end
end
