require "json"
require "busibe/connection"
require "busibe/request"

module Busibe
  class Client
    include Busibe::Connection
    include Busibe::Request

    attr_accessor(*Configuration::VALID_CONFIG_KEYS)
    attr_reader :response

    def initialize(options = {})
      merged_options = Busibe::Jusibe.options.merge(options)

      Configuration::VALID_CONFIG_KEYS.each do |key|
        send("#{key}=", merged_options[key])
      end
    end

    def send_sms(payload = {})
      if payload.empty?
        raise ArgumentError.new("A payload is required in order to send an sms")
      end

      post("/smsapi/send_sms", payload)
      self
    end

    def check_available_credits
      get("/smsapi/get_credits")
      self
    end

    def check_delivery_status(message_id = nil)
      if message_id.nil?
        raise ArgumentError.new("A message ID is required")
      end

      post("/smsapi/delivery_status?message_id=#{message_id}")
      self
    end

    def get_response
      JSON.load @response.body
    end

    private

    def method_missing(method_sym, *args, &_block)
      result = method_sym.to_s =~ /^(.*)_with_response$/
      super unless result
      send($1, *args).get_response
    end

    def respond_to_missing?(method_sym, include_private = false)
      method_sym.to_s =~ /^(.*)_with_response$/
      super unless respond_to? $1.to_sym
      true
    end
  end # Client
end
