require "busibe/connection"
require "busibe/request"
# Provides access to the Jusibe API http://jusibe.com
# Basic usage of the library is to call supported methods
# via the Client class.
#
# text = "After getting the MX1000 laser mouse and the
#  Z-5500 speakers i fell in love with logitech"
# Busibe::Client.new.sendSMS(text)
module Busibe
  class Client
    include Busibe::Connection
    include Busibe::Request

    attr_accessor(*Configuration::VALID_CONFIG_KEYS)

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

    def check_delivery_status(messageID = nil)
      if messageID.nil?
        raise ArgumentError.new("A message ID is required")
      end

      post("/smsapi/delivery_status?message_id=#{messageID}")
      self
    end

    def get_response
      @response
    end

    def self.method_missing(method_sym, *args, &block)
      if method_sym.to_s =~ /^(.*)_with_response$/
        send($1).get_response
      else
        super
      end
    end

    def self.respond_to?(method_sym, include_private = false)
      if method_sym.to_s =~ /^(.*)_with_response$/
        true
      else
        super
      end
    end
  end # Client
end
