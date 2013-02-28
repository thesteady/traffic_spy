require 'spec_helper'
require 'rspec'
require 'rack/test'

describe TrafficSpy::Router do

  include Rack::Test::Methods

  def app
    TrafficSpy::Router
  end

  describe "POST /sources" do

    context "with both identifier and rootUrl" do
      it "returns a 200(OK) with a body" do
        post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'

        last_response.should be_ok
        last_response.body.should eq "{\"identifier\":\"jumpstartlab\"}"
      end
    end

    context "with indentifier but without rootURL" do
      it "returns 400 with an error meesage" do
        post "/sources", :identifier => "jumpstartlab"
        last_response.status.should eq 400
        last_response.body.should eq "{\"message\":\"no url provided\"}"
      end
    end

    context "with rootURL but without identifier" do
      it "returns 400 with an error meesage" do
        post "/sources", :rootUrl => "http://jumpstartlab.com"
        last_response.status.should eq 400
        last_response.body.should eq "{\"message\":\"no identifier provided\"}"
      end
    end

    context "with both parameters but user already exists" do
      it "returns a 403(Forbidden) with an error message" do
        post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'
        post "/sources", :identifier => "jumpstartlab", :rootURL => 'http://jumpstartlab.com'

        last_response.status.should eq 403
        last_response.body.should eq "{\"message\":\identifier already exists\"}"
      end
    end

  end
end