module Busibe
  class Client
    # Provides access to the Jusibe API http://jusibe.com
    # Basic usage of the library is to call supported methods
    # via the Client class.
    #
    # text = "After getting the MX1000 laser mouse and the
    #  Z-5500 speakers i fell in love with logitech"
    # Busibe::Client.new.sendSMS(text)

    attr_accessor(*Configuration::VALID_CONFIG_KEYS)

    def initialize(options = {})
      merged_options = Busibe::Jusibe.options.merge(options)

      Configuration::VALID_CONFIG_KEYS.each do |key|
        send("#{key}=", merged_options[key])
      end

      # create an exceptions/erros folder : contains error, client_error, server_error classes
      # create a connection module : makes connection to faraday
      # include Connection and Request class
      # prepare_request : invokes the Connection class method
      # create a request class / module : define_method :get/:post
      # sendSMS return self
      # checkAvailableCredits return self
      # checkDeliveryStatus return self
      #
      # define a method_missing method that analyses methods with "_with_response"
      # gets the method name by splitting string by ("_with_response")
      # checks if method responds_to? class and calls method + gets response
      # i.e sendSMS_with_response("How are you doing?")  
      # http://technicalpickles.com/posts/using-method_missing-and-respond_to-to-create-dynamic-methods/
      #
      # getResponse return json_encoded response
    end

    
  end # Client
end
