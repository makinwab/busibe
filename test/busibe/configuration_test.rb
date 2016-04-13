require "helper"

describe Busibe::Configuration do 

  after do 
    Busibe.reset
  end

  Busibe::Configuration::VALID_CONFIG_KEYS.each do |key|
    describe ".#{key}" do
      it "should return the default value" do
        Busibe.send(key).must_equal Busibe::Configuration.const_get("DEFAULT_#{key.upcase}")
      end
    end
  end

  describe ".configure" do
    Busibe::Configuration::VALID_CONFIG_KEYS.each do |key|
      Busibe.configure do |config|
        config.send("#{key}=", key)
        Busibe.send(key).must_equal key
      end
    end
  end
end