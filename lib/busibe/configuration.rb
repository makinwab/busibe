module Busibe
  module Configuration
    VALID_CONNECTION_KEYS   = [:endpoint, :user_agent, :method].freeze
    VALID_OPTIONS_KEYS      = [:public_key, :access_token, :format].freeze
    VALID_CONFIG_KEYS       = VALID_CONNECTION_KEYS + VALID_OPTIONS_KEYS
 
    DEFAULT_ENDPOINT        = "https://jusibe.com"
    DEFAULT_METHOD          = :get
    DEFAULT_USER_AGENT      = "Busibe API Ruby Gem #{Busibe::VERSION}".freeze
 
    DEFAULT_PUBLIC_KEY      = nil
    DEFAULT_ACCESS_TOKEN    = nil
    DEFAULT_FORMAT          = :json

    attr_accessor(*VALID_CONFIG_KEYS)

    def self.extended(base)
      base.reset
    end

    #reset config settings
    def reset
      self.endpoint       = DEFAULT_ENDPOINT
      self.method         = DEFAULT_METHOD
      self.user_agent     = DEFAULT_USER_AGENT
 
      self.public_key     = DEFAULT_PUBLIC_KEY
      self.access_token   = DEFAULT_ACCESS_TOKEN
      self.format         = DEFAULT_FORMAT
    end

    def configure
      yield self
    end
  end #Configuration
end