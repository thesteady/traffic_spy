require 'spec_helper'
require 'rspec'
require 'rack/test'

describe TrafficSpy::Router do

  include Rack::Test::Methods

  def app
    TrafficSpy::Router
  end

  after do
    TrafficSpy::DB[:sites].delete
    TrafficSpy::DB[:requests].delete
    TrafficSpy::DB[:events].delete
    TrafficSpy::DB[:url_paths].delete
  end

  describe "POST /sources" do

    context "with both identifier and rootUrl" do
      it "returns a 200(OK) with a body" do

        post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'

        last_response.status.should eq 200
        last_response.body.should eq "{\"identifier\":\"jumpstartlab\"}"
      end
    end

    context "with identifier but without rootURL" do
      it "returns 400 with an error meesage" do

        post "/sources", :identifier => "jumpstartlab"

        last_response.status.should eq 400
        last_response.body.should eq "{\"message\":\"missing a parameter: provide identifier and rootUrl\"}"
      end
    end

    context "with rootURL but without identifier" do
      it "returns 400 with an error message" do

        post "/sources", :rootUrl => "http://jumpstartlab.com"

        last_response.status.should eq 400
        last_response.body.should eq "{\"message\":\"missing a parameter: provide identifier and rootUrl\"}"
      end
    end

    context "with both parameters but user already exists" do
      it "returns a 403(Forbidden) with an error message" do
        post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'
        post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'

        last_response.status.should eq 403
        last_response.body.should eq "{\"message\":\"identifier already exists\"}"
      end
    end
  end

  describe "POST /sources/:identifier/data" do

    context "when identifier does not exist" do
      it "returns an error message that the identifier does not exist" do
        post "/sources/pizza/data", :data => "some data"
        #last_response.status.should eq 403
        last_response.body.should eq "{\"message\":\"identifier does not exist\"}"
      end
    end
  end

  describe "GET /sources/:identifier" do

    context "when the identifier does not exist" do
      it "returns an error message that the identifier does not exist" do
        get "/sources/reggae"
        last_response.status.should eq 403
        last_response.body.should eq "{\"message\":\"identifier does not exist\"}"
      end
    end

    context "when the identifier does exist" do
      it "displays a page including summary of urls (most requested to least)" do
        post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'
        get '/sources/jumpstartlab'

        last_response.status.should eq 200
      end
    end
  end

  describe 'GET /sources/:identifier/urls/:rel_path' do
    before do
      post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'
      post "/sources/jumpstartlab/data", {:payload => Payload.sample1}
    end

    context "with a valid request" do
      it "displays page with url statistics" do
        get '/sources/jumpstartlab/urls/blog'
        last_response.status.should eq 200
      end
    end

    context "with a invalid url" do
      it "returns 403 status" do
        get '/sources/jumpstartlab/urls/stuff'
        last_response.status.should eq 403
      end
    end
  end


  describe "GET /sources/:identifier/events" do
    before do
      post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'
      post "/sources/jumpstartlab/data", {:payload => Payload.sample1}
    end

    context "when the identifier exists but does not have any events" do
      it "returns an error message that no events are defined" do
        get "/sources/jumpstartlab/reggae"

        last_response.status.should eq 404

        ###*** fix this test
        #last_response.body.should eq  "{\"message\":\"No events have been defined.\"}"
      end
    end

    context "when an identifier does not exist" do
      it "displays a message that no events are defined" do

        get "/sources/ohsnap/events"

        last_response.status.should eq 403
        last_response.body.should eq "{\"message\":\"identifier does not exist\"}"
      end
    end

    context "when the identifier exists AND events have been created" do
      it "displays the events in most received to least received, with links to each" do

        get "sources/jumpstartlab/events"
        last_response.status.should eq 200

      end
    end
  end
end
