require "spec_helper"

describe Busibe::Configuration do
  

  before :each do
    @busibe_config = Busibe::Configuration
    @busibe = Busibe::Jusibe
  end

  after do
    Busibe::Jusibe.reset
  end

  Busibe::Configuration::VALID_CONFIG_KEYS.each do |key|
    describe ".#{key}" do
      it "should return the default value" do
        value = @busibe.send(key)
        expect(value).to eq @busibe_config.const_get("DEFAULT_#{key.upcase}")
      end
    end
  end

  describe ".configure" do
    Busibe::Configuration::VALID_CONFIG_KEYS.each do |key|
      it "should set the value of #{key}" do
        @busibe.configure do |config|
          config.send("#{key}=", key)
          value = @busibe.send(key)
          expect(value).to eq key
        end
      end
    end
  end
end
