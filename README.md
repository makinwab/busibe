# Busibe

[![Coverage Status](https://coveralls.io/repos/github/andela-bmakinwa/busibe/badge.svg?branch=master)](https://coveralls.io/github/andela-bmakinwa/busibe?branch=master) [![Build Status](https://travis-ci.org/andela-bmakinwa/busibe.svg?branch=master)](https://travis-ci.org/andela-bmakinwa/busibe) [![Code Climate](https://codeclimate.com/github/andela-bmakinwa/busibe/badges/gpa.svg)](https://codeclimate.com/github/andela-bmakinwa/busibe)

> Jusibe Library for Ruby

Busibe is a ruby gem that consumes the services of [Jusibe](http:://jusibe.com). With this library, you can access the SMS functionalities provided by the Jusibe seamlessly.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'busibe'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install busibe

## Usage


#### Create a Client instance
```ruby
require "busibe"

# set configuration params
config = {
  public_key: "PUBLIC_KEY",
  access_token: "ACCESS_TOKEN"
}

# instantiate Client class
client = Busibe::Client.new(config)
```

#### Send SMS

```ruby
# data needed to send sms
payload = {
  to: "PHONE NUMBER",
  from: "Sender's name",
  message: "Do you love Ruby?"
}

begin
  client.send_sms payload # return instance of Client
  # OR
  client.send_sms(payload).get_response # return response body
rescue Exception => e
  puts e.message
end
```

##### Sample response body
```
{
  "status": "Sent",
  "message_id": "xeqd6rrd26",
  "sms_credits_used": 1
}
```

___
#### Check Available Credits

```ruby
begin
  client.check_available_credits # return instance of Client
  # OR
  client.check_available_credits.get_response # return response body
rescue Exception => e
  puts e.message
end
```

##### Sample response body
```
{
  "sms_credits": "182"
}
```
___

#### Check Delivery Status

```ruby
message_id = "MESSAGE ID"

begin
  # return instance of Client
  client.check_delivery_status message_id 
  # OR
  # return response body
  client.check_delivery_status(message_id).get_response 
rescue Exception => e
  puts e.message
end
```

##### Sample response body
```
{
  "sms_credits": "182"
}
```
___

##### Other available methods
```ruby
# sends sms and returns response
client.send_sms_with_response(payload)

# makes request and returns response
client.check_available_credits_with_response

# makes request and returns response
client.check_delivery_status_with_response
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rspec spec` to run the tests.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andela-bmakinwa/busibe.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

