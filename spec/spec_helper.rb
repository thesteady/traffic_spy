require 'simplecov'
SimpleCov.start

ENV["TRAFFIC_SPY_ENV"] = "test"
require 'traffic_spy'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end

class Payload
  def self.sample1
    '{
      "url":"http://jumpstartlab.com/blog",
      "requestedAt":"2013-02-16 21:38:28 -0700",
      "respondedIn":37,
      "referredBy":"http://jumpstartlab.com",
      "requestType":"GET",
      "parameters":[],
      "eventName": "socialLogin",
      "userAgent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      "resolutionWidth":"1920",
      "resolutionHeight":"1280",
      "ip":"63.29.38.211"
    }'
  end

  def self.sample2
    {
      url: "http://jumpstartlab.com/blog",
      requestedAt: "2013-02-16 21:38:28 -0700",
      respondedIn: 45,
      referredBy: "http://jumpstartlab.com",
      requestType: "GET",
      parameters: [],
      eventName: "Register",
      userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      resolutionWidth: "1920",
      resolutionHeight: "1280",
      ip: "63.29.38.211"
    }.to_json
  end

  def self.sample3
    {
      url: "http://jumpstartlab.com/blog",
      requestedAt: "2013-02-16 21:38:28 -0700",
      respondedIn: 40,
      referredBy: "http://jumpstartlab.com",
      requestType: "GET",
      parameters: [],
      eventName: "Login",
      userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      resolutionWidth: "1920",
      resolutionHeight: "1280",
      ip: "63.29.38.211"
    }.to_json
  end

  def self.sample4
    {
      url: "http://jumpstartlab.com/blog",
      requestedAt: "2013-02-16 21:38:28 -0700",
      respondedIn: 20,
      referredBy: "http://jumpstartlab.com",
      requestType: "GET",
      parameters: [],
      eventName: "socialLogin2",
      userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
      resolutionWidth: "1920",
      resolutionHeight: "1280",
      ip: "63.29.38.211"
    }.to_json
  end
end