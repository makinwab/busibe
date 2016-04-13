require 'spec_helper'

describe Busibe::Configuration do 

  after do 
    Busibe::Jusibe.reset
  end

  Busibe::Configuration::VALID_CONFIG_KEYS.each do |key|
    describe ".#{key}" do
      it "should return the default value" do
        value = Busibe::Jusibe.send(key)
        busibe_config = Busibe::Configuration
        expect(value).to eq busibe_config.const_get("DEFAULT_#{key.upcase}")
      end
    end
  end

  describe ".configure" do
    Busibe::Configuration::VALID_CONFIG_KEYS.each do |key|
      it "should set the value of #{key}" do
        Busibe::Jusibe.configure do |config|
          config.send("#{key}=", key)
          value = Busibe::Jusibe.send(key)
          expect(value).to eq key
        end
      end
    end
  end
end