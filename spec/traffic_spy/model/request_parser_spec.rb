require 'spec_helper'
require 'rspec'
require 'rack/test'
require 'json'

describe TrafficSpy::RequestParser do

  include Rack::Test::Methods


  describe "Payload is Parsed and Stored" do

    before do
      TrafficSpy::DB[:url_paths].delete
      TrafficSpy::DB[:sites].delete
    end

    context "when a new payload is received" do
      it "parses and creates a new request" do

        new_site = TrafficSpy::Site.new({:identifier=>"jumpstartlab", :rootUrl => "http://jumpstartlab.com"})
        new_site.save

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
        expect(object.site_id). to eq TrafficSpy::Site.find_by_rootUrl("http://jumpstartlab.com").id

        expect(parsed_payload.site_id).to eq TrafficSpy::Site.find_by_rootUrl("http://jumpstartlab.com").id
        expect(parsed_payload.response_time).to eq 37
        expect(parsed_payload.referred_by).to eq "http://jumpstartlab.com"
        expect(parsed_payload.request_type).to eq "GET"

        expect(parsed_payload.event_id).to eq TrafficSpy::Event.find_by_eventName("socialLogin").id
        expect(parsed_payload.browser_id).to eq "Chrome"
        expect(parsed_payload.os_id).to eq "Macintosh"

        expect(parsed_payload.resolution).to eq "1920 x 1280"
        expect(parsed_payload.ip).to eq "63.29.38.211"

      end
    end
  end

end
