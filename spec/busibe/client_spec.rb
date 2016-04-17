require "spec_helper"
require "dotenv"

describe Busibe::Client, vcr: true do
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
    context "when a payload is not given" do
      it "raises and ArgumentError" do
        @config = {
          public_key: ENV["PUBLIC_KEY"],
          access_token: ENV["ACCESS_TOKEN"]
        }

        api = Busibe::Client.new(@config)
        error = "A payload is required in order to send an sms"
        expect { api.send_sms }.to raise_error(ArgumentError, error)
      end
    end
    context "when a payload is given" do
      it "sends sms and returns self" do
        @config = {
          public_key: ENV["PUBLIC_KEY"],
          access_token: ENV["ACCESS_TOKEN"]
        }

        api = Busibe::Client.new(@config)
        payload = {
          to: ENV["PHONE_NO"],
          from: "Testing",
          message: "Muahahahaha. What's bubbling niggas?" # bug with url_encode
        }

        VCR.use_cassette("send_sms", record: :new_episodes) do
          expect(api.send_sms(payload)).to eq api
          expect(api.get_response["status"]).to eq "Sent"
        end
      end
    end
  end

  describe ".check_available_credits" do
    it "returns the sms credit" do
      @config = {
        public_key: ENV["PUBLIC_KEY"],
        access_token: ENV["ACCESS_TOKEN"]
      }
      api = Busibe::Client.new(@config)

      VCR.use_cassette("credits", record: :new_episodes) do
        result = api.check_available_credits

        expect(result).to eq api
        expect(result.get_response).to be_kind_of Hash
        expect(result.get_response["sms_credits"]).not_to be_empty
      end
    end
  end

  describe ".check_delivery_status" do
    context "when a messageID is not given" do
      it "raises an ArgumentError" do
        @config = {
          public_key: ENV["PUBLIC_KEY"],
          access_token: ENV["ACCESS_TOKEN"]
        }

        api = Busibe::Client.new(@config)
        error = "A message ID is required"
        expect { api.check_delivery_status }.to raise_error(
          ArgumentError,
          error
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
        message_id = ENV["MESSAGE_ID"]

        VCR.use_cassette("status", record: :new_episodes) do
          result = api.check_delivery_status(message_id)

          expect(result).to eq api
          expect(result.get_response["message_id"]).to eq message_id
          expect(result.get_response["status"]).not_to be_empty
          expect(result.get_response["date_sent"]).not_to be_empty
          expect(result.get_response["date_delivered"]).not_to be_empty
          expect(result.get_response["request_speed"]).not_to be_falsey
        end
      end
    end
  end

  describe ".get_response" do
    it "returns the response body" do
      @config = {
        public_key: ENV["PUBLIC_KEY"],
        access_token: ENV["ACCESS_TOKEN"]
      }

      api = Busibe::Client.new(@config)
      VCR.use_cassette("credits") do
        result = api.check_available_credits

        expect(result.get_response).to be_kind_of Hash
        expect(result.get_response["sms_credits"]).not_to be_empty
      end
    end
  end

  describe ".method_missing and .respond_to" do
    it "calls the 'check_available_credits' method and returns the response" do
      @config = {
        public_key: ENV["PUBLIC_KEY"],
        access_token: ENV["ACCESS_TOKEN"]
      }

      api = Busibe::Client.new(@config)
      VCR.use_cassette("credits") do
        result = api.check_available_credits_with_response

        expect(result).to be_kind_of Hash
        expect(result["sms_credits"]).not_to be_empty
      end
    end
  end
end
