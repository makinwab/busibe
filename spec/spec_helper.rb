require "coveralls"
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "busibe"
require "vcr"

VCR.configure do |c|
  c.cassette_library_dir = "spec/fixtures/.cassettes"
  c.hook_into :faraday
  c.default_cassette_options = {
    re_record_interval: 300 * 30
  }
end
