require 'spec_helper'
require 'rspec'
require 'rack/test'
require 'json'

describe TrafficSpy::Request do

  include Rack::Test::Methods

  def app
    TrafficSpy::Request
  end


##Rewrite this test and the class to just take in the data it needs, coming from the
### request parser already ready to go.
  # describe "New Request Instance" do
  #   context "given required parameters for a new request instance" do
  #     it "parses and creates a new request" do
  #       payload = {
  #                   :url => "http://jumpstartlab.com/blog",
  #                   :requestedAt => "2013-02-16 21:38:28 -0700",
  #                   :respondedIn => 37,
  #                   :referredBy => "http://jumpstartlab.com",
  #                   :requestType => "GET",
  #                   :parameters => [],
  #                   :eventName => "socialLogin",
  #                   :userAgent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
  #                   :resolutionWidth => "1920",
  #                   :resolutionHeight => "1280",
  #                   :ip => "63.29.38.211" 
  #                 }.to_json
                  
  #       new_request = app.new(payload)
  #       expect(new_request.path).to eq "http://jumpstartlab.com/blog"
  #       expect(new_request.respondedIn).to eq 37

  #     end
  #   end
  # end

end
