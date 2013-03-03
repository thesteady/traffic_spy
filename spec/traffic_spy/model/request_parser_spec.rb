require 'spec_helper'
require 'rspec'
require 'rack/test'
require 'json'
#require 'traffic_spy/models/url_path'

describe TrafficSpy::RequestParser do

  include Rack::Test::Methods


  describe "Payload is Parsed and Stored" do

    before do
      TrafficSpy::DB[:url_paths].delete
    end

    context "when a new payload is received" do
      it "parses and creates a new request" do
        payload = {
                    :url => "http://jumpstartlab.com/blog",
                    :requestedAt => "2013-02-16 21:38:28 -0700",
                    :respondedIn => 37,
                    :referredBy => "http://jumpstartlab.com",
                    :requestType => "GET",
                    :parameters => [],
                    :eventName => "socialLogin",
                    :userAgent => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                    :resolutionWidth => "1920",
                    :resolutionHeight => "1280",
                    :ip => "63.29.38.211"
                  }.to_json

        parsed_payload = TrafficSpy::RequestParser.new(payload)
        object = TrafficSpy::UrlPath.find_by_path("http://jumpstartlab.com/blog")

        expect(object.path).to eq "http://jumpstartlab.com/blog"
        expect(parsed_payload.respondedIn).to eq 37
        expect(parsed_payload.resolution).to eq "1920 x 1280"

      end
    end
  end

end
