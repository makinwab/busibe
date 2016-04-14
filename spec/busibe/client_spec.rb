require "spec_helper"

describe Busibe::Client do
  before do
    @keys = Busibe::Configuration::VALID_CONFIG_KEYS
  end

  context "with default Jusibe configurations" do
    before do
      Busibe::Jusibe.configure do |config|
        @keys.each do |key|
          config.send("#{key}=", key)
        end
      end
    end

    after do
      Busibe::Jusibe.reset
    end

    it "should inherit Jusibe configuration" do
      api = Busibe::Client.new
      @keys.each do |key|
        expect(api.send(key)).to eq key
      end
    end
  end

  context "with client class configuration" do
    before do
      @config = {
        public_key: "ak",
        access_token: "act",
        format: "of",
        endpoint: "ep",
        user_agent: "ua",
        method: "hm"
      }
    end

    it "should override module configuration" do
      api = Busibe::Client.new(@config)
      @keys.each do |key|
        expect(api.send(key)).to eq @config[key]
      end
    end

    it "should override Jusibe configuration after" do
      api = Busibe::Client.new

      @config.each do |key, value|
        api.send("#{key}=", value)
      end

      @keys.each do |key|
        expect(api.send(key.to_s)).to eq @config[key]
      end
    end
  end
end
