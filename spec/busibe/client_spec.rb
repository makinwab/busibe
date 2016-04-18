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
          request_method: "hm"
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
    subject do
      @config = {
        public_key: ENV["PUBLIC_KEY"],
        access_token: ENV["ACCESS_TOKEN"]
      }

      Busibe::Client.new(@config)
    end

    context "when a payload is not given" do
      it "raises and ArgumentError" do
        error = "A payload is required in order to send an sms"
        expect { subject.send_sms }.to raise_error(ArgumentError, error)
      end
    end

    context "when a payload is given" do
      it "sends sms and returns self" do
        payload = {
          to: ENV["PHONE_NO"],
          from: "Testing",
          message: "Muahahahaha. What's bubbling niggas?" # urlencode
        }

        VCR.use_cassette("send_sms", record: :new_episodes) do
          expect(subject.send_sms(payload)).to eq subject
          expect(subject.get_response["status"]).to eq "Sent"
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
    subject do
      @config = {
        public_key: ENV["PUBLIC_KEY"],
        access_token: ENV["ACCESS_TOKEN"]
      }

      Busibe::Client.new(@config)
    end

    context "when a messageID is not given" do
      it "raises an ArgumentError" do
        error = "A message ID is required"
        expect { subject.check_delivery_status }.to raise_error(
          ArgumentError,
          error
        )
      end
    end

    context "when a messageID is given" do
      it "retuns the delivery status response" do
        VCR.use_cassette("status", record: :new_episodes) do
          result = subject.check_delivery_status(ENV["MESSAGE_ID"])

          expect(result).to eq subject
          expect(result.get_response["message_id"]).to eq ENV["MESSAGE_ID"]
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

  describe ".method_missing / .respond_to" do
    subject do
      @config = {
        public_key: ENV["PUBLIC_KEY"],
        access_token: ENV["ACCESS_TOKEN"]
      }

      Busibe::Client.new(@config)
    end

    context "when the method does not exist" do
      it "return error" do
        expect { subject.invalid_method_with_response }.to raise_error(
          NoMethodError
        )
      end
    end

    context "when the method exists" do
      it "calls the method and returns the response" do
        VCR.use_cassette("credits") do
          result = subject.check_available_credits_with_response

          expect(result).to be_kind_of Hash
          expect(result["sms_credits"]).not_to be_empty
        end
      end
    end
  end

  describe ".respond_to" do
    subject do
      @config = {
        public_key: ENV["PUBLIC_KEY"],
        access_token: ENV["ACCESS_TOKEN"]
      }

      Busibe::Client.new(@config)
    end

    context "when the method does not exist" do
      it "raises an error" do
        expect { subject.method :invalid_with_response }.to raise_error(
          NameError
        )
      end
    end

    context "when the method exists" do
      it "does not raise an error" do
        expect { subject.method :send_sms_with_response }.to_not raise_error
      end
    end
  end
end
