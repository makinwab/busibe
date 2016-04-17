require "spec_helper"
require "dotenv"

describe Busibe::Client do
  before do
    @keys = Busibe::Configuration::VALID_CONFIG_KEYS
  end

  after do
    Busibe::Jusibe.reset
  end

  describe "constructor" do
    context "with default Jusibe configurations" do
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
        public_key: ENV["PUBLIC_KEY"],
        access_token: ENV["ACCESS_TOKEN"]
      }

      api = Busibe::Client.new
      payload = {
        to: "08063125510",
        from: "Testing",
        message: "Muahahahaha. What's bubbling niggas?" # bug with url_encode
      }

      client_api = double
      allow(client_api).to receive(:send_sms).with(payload).and_return(api)
      expect(client_api).to receive(:response)
      client_api.response
    end
  end

  describe ".check_available_credits" do
    it "returns the sms credit" do
      api = Busibe::Client.new
      client_api = double
      allow(client_api).to receive(:check_available_credits).and_return(api)
      expect(client_api).to receive(:response)
      client_api.response
    end
  end

  describe ".check_delivery_status" do
    context "when a messageID is not given" do
      it "raises an ArgumentError" do
        client_api = double

        allow(client_api).to receive(:check_delivery_status).
          and_raise(ArgumentError)

        expect { client_api.check_delivery_status }.to raise_error(
          ArgumentError
        )
      end
    end

    context "when a messageID is given" do
      it "retuns the delivery status response" do
        @config = {
          public_key: ENV["PUBLIC_KEY"],
          access_token: ENV["ACCESS_TOKEN"]
        }

        api = Busibe::Client.new(@config)
        message_id = "message_id"
        client_api = double

        allow(client_api).to receive(:check_delivery_status).
          with(message_id).and_return(api)
        result = client_api.check_delivery_status(message_id)

        expect(client_api).to receive(:response)
        expect(result).to be_kind_of Busibe::Client

        client_api.response
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

      allow_any_instance_of(Busibe::Client).to receive(:response).
        and_return(response)

      @config = {
        public_key: ENV["PUBLIC_KEY"],
        access_token: ENV["ACCESS_TOKEN"]
      }

      api = Busibe::Client.new(@config)
      client_api = double

      allow(client_api).to receive(:check_available_credits).and_return(api)
      allow(api).to receive(:get_response).and_return(response[:body])

      expect(api).to receive(:response)
      expect(api.get_response).to eq response[:body]

      api.response
    end
  end

  describe ".method_missing and .respond_to" do
    it "calls the 'check_available_credits' method and returns the response" do
      response = {
        body: {
          sms_credits: "182"
        }
      }

      allow_any_instance_of(Busibe::Client).to receive(:response).
        and_return(response)

      @config = {
        public_key: ENV["PUBLIC_KEY"],
        access_token: ENV["ACCESS_TOKEN"]
      }

      api = Busibe::Client.new(@config)
      client_api = double

      allow(client_api).to receive(:check_available_credits).and_return(api)
      allow(client_api).to receive(:get_response).and_return(response[:body])
      allow(client_api).to receive(:method_missing).and_return(response[:body])
      allow(client_api).to receive(:respond_to?).and_return(true)

      result = client_api.check_available_credits_with_response

      expect(result).to be_kind_of Hash
      expect(result[:sms_credits]).not_to be_empty
      expect(result[:sms_credits]).to eq "182"
    end
  end
end
