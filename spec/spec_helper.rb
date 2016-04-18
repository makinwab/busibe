require "coveralls"
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "busibe"
require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/.cassettes"
  c.hook_into :faraday
  c.filter_sensitive_data("message_id") do
    ENV["MESSAGE_ID"]
  end
end
