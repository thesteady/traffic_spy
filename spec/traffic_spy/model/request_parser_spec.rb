require 'spec_helper'
require 'rspec'
require 'rack/test'
require 'json'

describe TrafficSpy::RequestParser do

  include Rack::Test::Methods

  after do
    TrafficSpy::DB[:sites].delete
    TrafficSpy::DB[:requests].delete
    TrafficSpy::DB[:events].delete
    TrafficSpy::DB[:url_paths].delete
  end


  describe "Payload is Parsed and Stored" do

    context "when a new payload is received" do
      it "parses and creates a new request and saves data in associated tables" do

        site = TrafficSpy::Site.new({:identifier=>"jumpstartlab", :rootUrl => "http://jumpstartlab.com"})
        site.save

        payload = Payload.sample1

        request_hash = TrafficSpy::RequestParser.new(payload).create_request

        object = TrafficSpy::UrlPath.find(path: "http://jumpstartlab.com/blog")

        expect(object.path).to eq "http://jumpstartlab.com/blog"
        expect(object.site_id).to eq TrafficSpy::Site.find(rootUrl: "http://jumpstartlab.com").id

        # expect(parsed_payload.site_id).to eq TrafficSpy::Site.find_by_rootUrl("http://jumpstartlab.com").id
        # expect(parsed_payload.response_time).to eq 37
        # expect(parsed_payload.referred_by).to eq "http://jumpstartlab.com"
        # expect(parsed_payload.request_type).to eq "GET"

        # expect(parsed_payload.event_id).to eq TrafficSpy::Event.find_by_eventName("socialLogin").id
        # expect(parsed_payload.browser_id).to eq TrafficSpy::Browser.find_by_name("Chrome").id
        # expect(parsed_payload.os_id).to eq TrafficSpy::OperatingSystem.find_by_name("Macintosh").id
        # expect(parsed_payload.resolution).to eq "1920 x 1280"
        # expect(parsed_payload.ip).to eq "63.29.38.211"

      end
    end
  end

end
