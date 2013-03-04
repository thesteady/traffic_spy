require 'spec_helper'
require 'rspec'
require 'rack/test'
require 'json'

describe TrafficSpy::Request do

  include Rack::Test::Methods

  def app
    TrafficSpy::Request
  end

  describe "Class method" do

    before do
      TrafficSpy::DB[:requests].delete
    end

    let(:req1) do
      { :url_path_id => 1, :event_id => 1,
        :browser_id => 1, :os_id => 1,
        :site_id => 1, :requested_at => "2013-02-16 21:38:28 -0700",
        :responded_at => 37,
        :referred_by => "http://jumpstartlab.com", :request_type => "GET",
        :resolution => "1920 x 1280",
        :ip => "63.29.38.211"}
    end

    let(:req2) do
      { :url_path_id => 2, :event_id => 2,
        :browser_id => 2, :os_id => 2,
        :site_id => 2, :requested_at => "2013-02-17 21:38:28 -0700",
        :responded_at => 40,
        :referred_by => "http://espn.com", :request_type => "GET",
        :resolution => "800 x 600",
        :ip => "63.29.89.211"}
    end

    let(:req3) do
      { :url_path_id => 3 , :event_id => 3,
        :browser_id => 3, :os_id => 2,
        :site_id => 1, :requested_at => "2013-02-17 21:38:28 -0700",
        :responded_at => 40,
        :referred_by => "http://yahoo.com", :request_type => "GET",
        :resolution => "1920 x 1280",
        :ip => "63.9.89.231"}
    end

    describe "new" do
      it "should create new instance" do
        request = app.new(req3)
        expect(request.referred_by).to eq("http://yahoo.com")
      end
    end

    describe ".count" do
      it  "returns 3 records" do
        request1 = app.new(req1).save
        request2 = app.new(req2).save
        request3 = app.new(req3).save

        expect(app.count).to eq(3)
      end
    end

    describe ".all" do
      it "returns 2 records" do
        app.new(req1).save
        app.new(req2).save
        expect(app.all.count).to eq(2)
      end
    end

    describe ".find(input)" do

      before do
        @req1 = app.new(req1)
        @req1_id = @req1.save
        @req2 = app.new(req2)
        @req2_id = @req2.save
        @req3 = app.new(req3)
        @req3_id = @req3.save
      end

      context "using id as parameter" do
        it "returns first record that matches given parameter" do

          # find out why response_time is nil after save
          # puts @req1.inspect
          # puts @req2.inspect
          # puts @req3.inspect
          # puts "**************"

          # # raise " yo yo #{@req1_id}"
          #puts app.find(id: @req1_id).inspect
          expect(app.find(id: @req1_id).first.resolution).to eq("1920 x 1280")
        end
      end

      context "using site_id as parameter" do
        it "returns first record that matches given parameter" do
          expect(app.find(site_id: 2).first.os_id).to eq(2)
        end
      end

      context "using event_id as parameter" do
        it "returns first record that matches given parameter" do
          expect(app.find(event_id: 3).first.referred_by).to eq("http://yahoo.com")
        end
      end

      context "using browser_id as parameter" do
        it "returns first record that matches given parameter" do
          expect(app.find(browser_id: 2).first.referred_by).to eq("http://espn.com")
        end
      end

      context "using url_path_id as parameter" do
        it "returns first record that matches given parameter" do
          expect(app.find(url_path_id: 2).first.resolution).to eq("800 x 600")
        end
      end

      context "using os_id as parameter" do
        it "returns first record that matches given parameter" do
          expect(app.find(os_id: 2).last.site_id).to eq(1)
        end
      end

      context "using resolution as parameter" do
        it "returns first record that matches given parameter" do
          expect(app.find(resolution: "1920 x 1280").first.os_id).to eq(1)
        end
      end
    end

  end

  describe "When new Requests are received from RequestParser" do

    before do
      @site = TrafficSpy::Site.new({:identifier=>"jumpstartlab", :rootUrl => "http://jumpstartlab.com"})
      @site.save

      @payload = {
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

      request_hash = TrafficSpy::RequestParser.new(@payload).create_request

      @request = app.find(id: request_hash[:id]).first
    end

    describe "non-foreign key fields" do

      it "should match payload attributes" do
       # puts @request.inspect
        expect(@request.resolution).to eq("1920 x 1280")
        expect(@request.ip).to eq("63.29.38.211")
        expect(@request.request_type).to eq("GET")
      end
    end

    describe "foreign keys" do
      it "should retrieve url path from url_paths table" do
        url_id = @request.url_path_id
        expect(TrafficSpy::UrlPath.find(id: url_id).path).to eq("http://jumpstartlab.com/blog")
      end

      it "should retrieve site identifier from sites table" do
        site_id = @request.site_id
        expect(TrafficSpy::Site.find(id: site_id).identifier).to eq("jumpstartlab")
      end

      it "should retrieve event name from events table" do
        event_id = @request.event_id
        expect(TrafficSpy::Event.find(id: event_id).name).to eq("socialLogin")
      end

      it "should retrieve browser name from browsers table" do
        browser_id = @request.browser_id
        expect(TrafficSpy::Browser.find(id: browser_id).name).to eq("Chrome")
      end

      it "should retrieve os name from operation_systems table" do
        os_id = @request.os_id
        expect(TrafficSpy::OperatingSystem.find(id: os_id).name).to eq("Macintosh")
      end
    end

    describe ".summarize_url_requests_for_site(site_id)" do
      it "returns a hash of url_path_id => count for a site's requests" do
        #mock a site_id =>1
        #mock some requests
        #Request.summarize_url_requests_for_site(1)
        pending
      end
    end

  end
end
