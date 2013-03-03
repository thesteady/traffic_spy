require 'spec_helper'
require 'rspec'
require 'rack/test'

describe TrafficSpy::Router do

  include Rack::Test::Methods

  def app
    TrafficSpy::Router
  end

  describe "POST /sources" do

    before do
      TrafficSpy::DB[:sites].delete
    end

    context "with both identifier and rootUrl" do
      it "returns a 200(OK) with a body" do

        post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'

        last_response.status.should eq 200
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
        post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'

        last_response.status.should eq 403
        last_response.body.should eq "{\"message\":\identifier already exists\"}"
      end
    end

  end

  describe "POST /sources/:identifier/data" do
    context "identifier does not exist" do
      it "returns an error message that the identifier does not exist" do
        post "/sources/pizza/data", :data => "some data"
        last_response.status.should eq 403
        last_response.body.should eq "{\"message\":\identifier does not exist\"}"
      end
    end
  end

  describe "GET /sources/:identifier" do
    before do
      TrafficSpy::DB[:sites].delete
    end

    context "when the identifier does not exist" do
      it "returns an error message that the identifier does not exist" do
        get "/sources/reggae"
        last_response.status.should eq 404
        last_response.body.should eq "{\"message\":\identifier does not exist\"}"
      end
    end

    context "when the identifier does exist" do
      it "displays a page including summary of urls (most requested to least)" do
        pending
        #expect(method summarizing list of urls.count). to eq 5

      end
    end
  end
end
