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

    # context "with both identifier and rootUrl" do
    #   it "returns a 200(OK) with a body" do

    #     post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'

    #     last_response.status.should eq 200
    #     last_response.body.should eq "{\"identifier\":\"jumpstartlab\"}"
    #   end
    # end

    # context "with indentifier but without rootURL" do
    #   it "returns 400 with an error meesage" do

    #     post "/sources", :identifier => "jumpstartlab"

    #     last_response.status.should eq 400
    #     last_response.body.should eq "{\"message\":\"no url provided\"}"
    #   end
    # end

    # context "with rootURL but without identifier" do
    #   it "returns 400 with an error meesage" do

    #     post "/sources", :rootUrl => "http://jumpstartlab.com"

    #     last_response.status.should eq 400
    #     last_response.body.should eq "{\"message\":\"no identifier provided\"}"
    #   end
    # end

    # context "with both parameters but user already exists" do
    #   it "returns a 403(Forbidden) with an error message" do
    #     post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'
    #     post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'

    #     last_response.status.should eq 403
    #     last_response.body.should eq "{\"message\":\identifier already exists\"}"
    #   end
    # end
  end


  describe "POST /sources/:identifier/data" do
    context "when identifier does not exist" do
      it "returns an error message that the identifier does not exist" do
        post "/sources/pizza/data", :data => "some data"
        #last_response.status.should eq 403
        last_response.body.should eq "{\"message\":\ identifier does not exist\"}"
      end
    end
  end


######################## GET METHODS ###########################################
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
        post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'
        get '/sources/jumpstartlab'

        pending
        #last_response.status.should eq 200
       # expect(requested_urls_stats.count) to eq 5
      end
    end
  end

  describe "GET /sources/:identifier/events" do
    before do
      TrafficSpy::DB[:sites].delete
      TrafficSpy::DB[:events].delete
    end

    context "when the identifier does not exist" do
      it "returns an error message that the identifier does not exist" do
        get "/sources/reggae"
        #last_response.status.should eq 404
        last_response.body.should eq "{\"message\":\identifier does not exist\"}"
      end
    end

    context "when the identifier does exist AND events have been created" do
      it "displays the events in most received to least received, with links to each" do
        post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'
        #post a couple of payloads with events defined
        get "sources/jumpstartlab/events"

      pending
      #will show page with hyperlinks to each event specific page details
      end
    end

    context "when identifier exists but NO events are defined" do
      it "displays a message that no events are defined" do
        post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'
        get "/sources/jumpstartlab/events"

        last_response.body.should eq "{\"message\":\no events have been defined.\"}"
      end
    end

  end
end
