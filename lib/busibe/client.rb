module Busibe
  class Client
    # Provides access to the Jusibe API http://jusibe.com
    # Basic usage of the library is to call supported methods via the Client class.
    #
    # text = "After getting the MX1000 laser mouse and the Z-5500 speakers i fell in love with logitech"
    # Busibe::Client.new.sendSMS(text)

    attr_accessor(*Configuration::VALID_CONFIG_KEYS)

    def initialize(options={})
      merged_options = Busibe::Jusibe.options.merge(options)
      
      Configuration::VALID_CONFIG_KEYS.each do |key|
        send("#{key}=", merged_options[key])
      end
    end
  end # Client
end