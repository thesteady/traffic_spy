require 'spec_helper'
require 'rspec'
require 'rack/test'

def register_jumpstartlab
  post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'
end

def submit_jumpstart_payload
  payload = {
                    url: "http://jumpstartlab.com/blog",
                    requestedAt: "2013-02-16 21:38:28 -0700",
                    respondedIn: 37,
                    referredBy: "http://jumpstartlab.com",
                    requestType: "GET",
                    parameters: [],
                    eventName: "socialLogin",
                    userAgent: "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                    resolutionWidth: "1920",
                    resolutionHeight: "1280",
                    ip: "63.29.38.211"
                  }.to_json

  post "/sources/jumpstartlab/data", {payload: payload}

end

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

        #post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'
        register_jumpstartlab

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
        # post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'
        # post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'
        register_jumpstartlab
        register_jumpstartlab

        last_response.status.should eq 403
        last_response.body.should eq "{\"message\":\"identifier already exists\"}"
      end
    end
  end





  describe "POST /sources/:identifier/data" do
    before do
      register_jumpstartlab
    end

    after do
      TrafficSpy::DB[:sites].delete
      TrafficSpy::DB[:requests].delete
    end

    context "when identifier does not exist" do
      it "returns an error message that the identifier does not exist" do
        post "/sources/pizza/data", :data => "some data"
        #last_response.status.should eq 403
        last_response.body.should eq "{\"message\":\"identifier does not exist\"}"
      end
    end
#######
    context "when an identifier does exist AND" do
      context "when the payload is redundant" do
        it "returns a 403 error with message" do
            submit_jumpstart_payload
            submit_jumpstart_payload

          last_response.status.should eq 403
          last_response.body.should eq "{\"message\":\"payload has already been submitted\"}"
        end
      end
#######
      context "when the payload is empty" do
        it "returns a 400 Bad Request with message" do
          payload = {}
          post "/sources/jumpstartlab/data", {payload: payload}

          last_response.status.should eq 400
          last_response.body.should eq "{\"message\":\"payload was empty\"}"
        end
      end

      context "when the payload is unique" do
        it "returns a 200 OK" do
          submit_jumpstart_payload

          last_response.status.should eq 200
        end
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
      post "/sources/jumpstartlab/data", {:payload => Payload.sample}
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
      TrafficSpy::DB[:sites].delete
      TrafficSpy::DB[:events].delete
    end

    context "when the identifier does not exist" do
      it "returns an error message that the identifier does not exist" do
        get "/sources/reggae"
        #last_response.status.should eq 404
        last_response.body.should eq "{\"message\":\"identifier does not exist\"}"
      end
    end

    context "when identifier exists but NO events are defined" do
      it "displays a message that no events are defined" do
        site = TrafficSpy::Site.new(:identifier=>"ohsnap", :rootUrl =>'http://ohsnap.com')
        site.save
        get "/sources/ohsnap/events"

        last_response.body.should eq "{\"message\":\"no events have been defined.\"}"
      end
    end

    context "when the identifier does exist AND events have been created" do
      it "displays the events in most received to least received, with links to each" do
        post "/sources", :identifier => "jumpstartlab", :rootUrl => 'http://jumpstartlab.com'

        site_id = TrafficSpy::Site.find(:identifier=>'jumpstartlab').id
        TrafficSpy::Event.new(:name=>"login", :site_id =>site_id)

        get "sources/jumpstartlab/events"
        last_response.status.should eq 200
      #will show page with hyperlinks to each event specific page details
      end
    end
  end
end
