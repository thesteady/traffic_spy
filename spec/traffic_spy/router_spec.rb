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

    context "with both identifier and rootUrl" do
      it "returns a 200(OK) with a body" do
        register_jumpstartlab

        last_response.status.should eq 200
        last_response.body.should eq "{\"identifier\":\"jumpstartlab\"}"
      end
    end

    context "with identifier but without rootURL" do
      it "returns 400 with an error meesage" do
        post "/sources", :identifier => "jumpstartlab"

        last_response.status.should eq 400
        last_response.body.should eq "{\"message\":\"no identifier or rootUrl\"}"
      end
    end

    context "with rootURL but without identifier" do
      it "returns 400 with an error message" do
        post "/sources", :rootUrl => "http://jumpstartlab.com"

        last_response.status.should eq 400
        last_response.body.should eq "{\"message\":\"no identifier or rootUrl\"}"
      end
    end

    context "with both parameters but user already exists" do
      it "returns a 403(Forbidden) with an error message" do
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

    context "when identifier does not exist" do
      it "returns an error message that the identifier does not exist" do
        post "/sources/pizza/data", :data => "some data"

        last_response.status.should eq 403
        last_response.body.should eq "{\"message\":\"identifier does not exist\"}"
      end
    end

    context "when an identifier does exist AND" do
      context "when the payload is redundant" do
        it "returns a 403 error with message" do
            submit_jumpstart_payload
            submit_jumpstart_payload

          last_response.status.should eq 403
          last_response.body.should eq "{\"message\":\"payload has already been submitted\"}"
        end
      end

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
      TrafficSpy::Site.new(id: 1, identifier: "jumpstartlab", rootUrl: "http://jumpstartlab.com").save
      TrafficSpy::RequestParser.new(Payload.sample1).create_request
      TrafficSpy::RequestParser.new(Payload.sample2).create_request
      TrafficSpy::RequestParser.new(Payload.sample3).create_request
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
        get '/sources/jumpstartlab'
        last_response.status.should eq 200
      end

      # it 'correctly summarizes url counts' do
      #   get '/sources/jumpstartlab'
      #   doc = Nokogiri::HTML(last_response.body)
      #   urls_table = (doc / "table#urls")
      #   blog_row = (urls_table / "tr").detect { |r| r.text() =~ /blog/ }
      #   count = (blog_row / "td").last.text.to_i

      #   count.should eq 3
      # end
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

    context "when the identifier does not exist" do
      it "returns an error message that the identifier does not exist" do
        get "/sources/reggae"
        last_response.status.should eq 403
        last_response.body.should eq "{\"message\":\"identifier does not exist\"}"
      end
    end

    context "when the identifier exists but does not have any events" do
      it "returns an error message that no events are defined" do
        get "/sources/jumpstartlab/reggae"

        last_response.status.should eq 404
        pending
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

  describe "POST /sources/:identifier/campaigns" do
    before do
      TrafficSpy::Site.new(id: 1, identifier: "jumpstartlab", rootUrl: "http://jumpstartlab.com").save
      TrafficSpy::RequestParser.new(Payload.sample3).create_request
      TrafficSpy::RequestParser.new(Payload.sample4).create_request
      TrafficSpy::RequestParser.new(Payload.sample5).create_request
    end

    def post_campaign_jumpstartlab
      post 'sources/jumpstartlab/campaigns', 'campaignName=socialSignup&eventNames[]=socialLogin&eventNames[]=Login'
    end

    context "when identifier does not exist" do
      it "returns an error message with 403" do
        post 'sources/puma/campaigns', 'campaignName=socialSignup&eventNames[]=socialLogin&eventNames[]=Login'


        last_response.status.should eq 403
        last_response.body.should eq "{\"message\":\"identifier does not exist\"}"
      end
    end

    context "when identifier exists" do
      before do
        post 'sources' , :identifier =>'puma', :rootUrl=>"http://puma.com"
      end

      context "campaign already exists" do
        it "returns 403 and descriptive message" do
          post_campaign_jumpstartlab
          post_campaign_jumpstartlab
          last_response.status.should eq 403
          last_response.body.should eq "{\"message\":\"campaign already exists\"}"
        end
      end
      context "new campaign" do
        context "AND valid parameters" do
          it "returns 200 OK" do
            post_campaign_jumpstartlab
            last_response.status.should eq 200
          end
        end

          context "BUT campaignName is missing" do
            it "returns a 400 Bad Request with message" do
              post 'sources/jumpstartlab/campaigns', 'campaignName=&eventNames[]=addedSocialThroughPromptA&eventNames[]=addedSocialThroughPromptB'
              last_response.status.should eq 400
              last_response.body.should eq '{"message":"missing parameter campaignName or eventNames"}'
            end
          end

          context "BUT eventName(s) is/are missing" do
            it "returns a 400 Bad Request with message" do
              post 'sources/jumpstartlab/campaigns', 'campaignName=sellShoes'

              last_response.status.should eq 400
              last_response.body.should eq '{"message":"missing parameter campaignName or eventNames"}'
            end
          end
      end

    end
  end

  describe "GET /sources/:identifier/campaigns" do
    before do
      post 'sources' , :identifier =>'jumpstartlab', :rootUrl=>"http://jumpstartlab.com"
    end

    context "when no campaigns are defined" do
      it "displays a message that no campaigns have been defined" do
        get 'sources/jumpstartlab/campaigns'

        last_response.body.should eq '{"message":"No campaigns have been defined."}'
      end
    end

    context "when a campaign exists" do
      it "displays a page with hyperlinks to specific data" do
        post 'sources/jumpstartlab/campaigns', 'campaignName=socialSignup&eventNames[]=addedSocialThroughPromptA&eventNames[]=addedSocialThroughPromptB'
        get 'sources/jumpstartlab/campaigns'

        last_response.status.should eq 200
      end
    end
  end

  describe "GET /sources/:identifier/campaigns/:campaignname" do
    before do
      post 'sources' , :identifier =>'jumpstartlab', :rootUrl=>"http://jumpstartlab.com"
    end

    context "when the campaign exists" do
      it "displays campaign events ranked most received to least received" do
        TrafficSpy::RequestParser.new(Payload.sample3).create_request
        TrafficSpy::RequestParser.new(Payload.sample4).create_request
        TrafficSpy::RequestParser.new(Payload.sample5).create_request
        post 'sources/jumpstartlab/campaigns', 'campaignName=socialSignup&eventNames[]=Login&eventNames[]=socialLogin'
        get 'sources/jumpstartlab/campaigns/socialSignup'
        last_response.status.should eq 200
      end
    end

    context "when the campaign does not exist" do
      it "displays a message that no campaign with that name exists" do
        post 'sources/jumpstartlab/campaigns', 'campaignName=socialSignup&eventNames[]=addedSocialThroughPromptA&eventNames[]=addedSocialThroughPromptB'
        get 'sources/jumpstartlab/campaigns/notacampaign'

        last_response.status.should eq 403
      end
    end
  end

  describe "GET /sources/:identifier/events/:event_name" do
    before do
      TrafficSpy::Site.new(id: 1, identifier: "jumpstartlab", rootUrl: "http://jumpstartlab.com").save
      TrafficSpy::RequestParser.new(Payload.sample4).create_request
      TrafficSpy::RequestParser.new(Payload.sample5).create_request
    end

    context "when request is valid" do

      it "should return display page with event details" do

        get "sources/jumpstartlab/events/socialLogin"
        last_response.status.should eq 200
      end
    end

    context "when request is invalid" do
      it "should return a 403 status" do

        get "sources/jumpstartlab/events/idunno"
        last_response.status.should eq 403
      end
    end
  end
end
