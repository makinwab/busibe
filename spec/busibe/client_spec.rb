require "spec_helper"
require "pry"

describe Busibe::Client do
  before do
    @keys = Busibe::Configuration::VALID_CONFIG_KEYS
  end

  describe "constructor" do
    context "with default Jusibe configurations" do
      after do
        Busibe::Jusibe.reset
      end

      it "should inherit Jusibe configuration" do
        Busibe::Jusibe.configure do |config|
          @keys.each do |key|
            config.send("#{key}=", key)
          end
        end

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

  describe ".send_sms" do
    context "when stubbing Faraday" do
      it "sends sms and returns the response" do
        stubs = Faraday::Adapter::Test::Stubs.new do |stub|
          stub.get("/tamago") { |_env| [200, {}, "egg"] }
        end

        test = Faraday.new do |builder|
          builder.adapter :test, stubs do |stub|
            stub.get("/ebi") { |_env| [200, {}, "shrimp"] }
          end
        end

        expect((test.get "/tamago").body).to eq "egg"
        expect((test.get "/ebi").body).to eq "shrimp"
      end
    end

    context "without stubbing Faraday" do
      it "sends sms and returns response" do
        @config = {
          public_key: "60f541c01bff2ff55bf8ce7643009683",
          access_token: "45c3c5877d88c2aad5263bae924ddada"
        }

        api = Busibe::Client.new(@config)
        payload = {
          to: "08063125510",
          from: "Testing",
          message: "Muahahahaha. What's bubbling niggas?" # bug with url_encode
        }

        expect(api.send_sms(payload).get_response["status"]).to eq "Sent"
      end
    end
  end
end
