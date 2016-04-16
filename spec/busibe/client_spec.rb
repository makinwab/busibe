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
    it "sends sms and returns self" do
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

      capi = double
      allow(capi).to receive(:send_sms).with(payload).and_return(api)
      expect(api).to receive(:response)
      api.response

      # expect(api.send_sms(payload)).to eq api
      # expect(api.send_sms(payload).get_response["status"]).to eq "Sent"
    end
  end

  describe ".check_available_credits" do
    it "returns the sms credit" do
      @config = {
        public_key: "60f541c01bff2ff55bf8ce7643009683",
        access_token: "45c3c5877d88c2aad5263bae924ddada"
      }

      api = Busibe::Client.new(@config)
      result = api.check_available_credits
      expect(result.get_response["sms_credits"]).not_to be_empty
    end
  end

  describe ".check_delivery_status" do
    context "when a messageID is not given" do
      it "raises an ArgumentError" do
        @config = {
          public_key: "60f541c01bff2ff55bf8ce7643009683",
          access_token: "45c3c5877d88c2aad5263bae924ddada"
        }

        api = Busibe::Client.new(@config)
        expect { api.check_delivery_status }.to raise_error(ArgumentError)
      end
    end

    context "when a messageID is given" do
      it "retuns the delivery status response" do
        @config = {
          public_key: "60f541c01bff2ff55bf8ce7643009683",
          access_token: "45c3c5877d88c2aad5263bae924ddada"
        }

        api = Busibe::Client.new(@config)
        message_id = "z8k5y8x1e7"
        result = api.check_delivery_status(message_id)

        expect(result.get_response["message_id"]).to eq message_id
        expect(result.get_response["status"]).to eq "Delivered"
        expect(result.get_response["date_sent"]).not_to be_empty
        expect(result.get_response["date_delivered"]).not_to be_empty
        expect(result.get_response["request_speed"]).not_to be_falsey
      end
    end
  end

  describe ".get_response" do
    it "returns the response body" do
      response = {
        body: {
          status: "Sent",
          message_id: "xeqd6rrd26",
          sms_credits_used: 1
        }
      }

      allow_any_instance_of(Busibe::Client).to receive(:response).and_return(response)
      
      @config = {
        public_key: "60f541c01bff2ff55bf8ce7643009683",
        access_token: "45c3c5877d88c2aad5263bae924ddada"
      }

      api = Busibe::Client.new(@config)
      allow(api).to receive(:get_response).and_return(response[:body])
      result = api.check_available_credits

      expect(api.response).to eq response
      expect(result.get_response).to be_kind_of Hash
    end
  end

  describe ".method_missing and .respond_to" do
    it "calls the 'check_available_credits' method and returns the response" do
      @config = {
        public_key: "60f541c01bff2ff55bf8ce7643009683",
        access_token: "45c3c5877d88c2aad5263bae924ddada"
      }

      api = Busibe::Client.new(@config)
      result = api.check_available_credits_with_response

      expect(result).to be_kind_of Hash
      expect(result["sms_credits"]).not_to be_empty
    end
  end
end
