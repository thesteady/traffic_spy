require 'spec_helper'
require 'rspec'
require 'rack/test'
require 'json'

describe TrafficSpy::RequestParser do

  include Rack::Test::Methods

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

      end
    end
  end

end
