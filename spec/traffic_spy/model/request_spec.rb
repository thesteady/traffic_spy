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
        :response_time => 37,
        :referred_by => "http://jumpstartlab.com", :request_type => "GET",
        :resolution => "1920 x 1280",
        :ip => "63.29.38.211"}
    end

    let(:req2) do
      { :url_path_id => 2, :event_id => 2,
        :browser_id => 2, :os_id => 2,
        :site_id => 2, :requested_at => "2013-02-17 21:38:28 -0700",
        :response_time => 40,
        :referred_by => "http://espn.com", :request_type => "GET",
        :resolution => "800 x 600",
        :ip => "63.29.89.211"}
    end

    let(:req3) do
      { :url_path_id => 3 , :event_id => 3,
        :browser_id => 3, :os_id => 2,
        :site_id => 1, :requested_at => "2013-02-17 21:38:28 -0700",
        :response_time => 40,
        :referred_by => "http://yahoo.com", :request_type => "GET",
        :resolution => "1920 x 1280",
        :ip => "63.9.89.231"}
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

    describe ".find_by_id(id)" do
      it "returns record for provided id" do
        app.new(req1).save
        app.new(req2).save

        test_id = app.all.first.id
        expect(app.find_by_id(test_id).referred_by).to eq("http://jumpstartlab.com")
      end
    end

    describe ".find_by_site_id(id)" do
      it "returns records for provided site_id" do
        app.new(req1).save
        app.new(req2).save

        expect(app.find_by_site_id(2).first.referred_by).to eq("http://espn.com")
      end
    end

    describe ".find_by_event_id(id)" do
      it "returns records for provided event_id" do
        app.new(req1).save
        app.new(req2).save
        app.new(req3).save

        expect(app.find_by_event_id(3).first.referred_by).to eq("http://yahoo.com")
      end
    end

    describe ".find_by_browser_id(id)" do
      it "returns records for provided browser_id" do
        app.new(req1).save
        app.new(req2).save
        app.new(req3).save

        expect(app.find_by_browser_id(2).first.referred_by).to eq("http://espn.com")
      end
    end

    describe ".find_by_url_path_id(id)" do
      it "returns records for provided url_path_id" do
        app.new(req1).save
        app.new(req2).save
        app.new(req3).save

        expect(app.find_by_browser_id(1).first.referred_by).to eq("http://jumpstartlab.com")
      end
    end

    describe ".find_by_os_id(id)" do
      it "returns records for provided os_id" do
        app.new(req1).save
        app.new(req2).save
        app.new(req3).save

        expect(app.find_by_os_id(2).last.referred_by).to eq("http://yahoo.com")
      end
    end

    describe ".find_by_resolution(res)" do
      it "returns records for provided resolution" do
        app.new(req1).save
        app.new(req2).save
        app.new(req3).save

        expect(app.find_by_resolution("800 x 600").last.referred_by).to eq("http://espn.com")
      end
    end

    describe ".summarize_url_requests_for_site(site_id)" do
      it "returns a hash of url_path_ids=>count for a site's requests" do
        #mock a site_id =>1
        #mock some requests
        #Request.summarize_url_requests_for_site(1)
        pending
      end
    end

    # describe ".exists?(identifier)" do

    #   context "record exists in db" do
    #     it 'should return true' do
    #       app.new(site1).save
    #       site = app.all.first

    #       expect(app.exists?(site.identifier).should be_true)
    #     end
    #   end

    #   context "record does not exist in db" do
    #     it 'should return false' do
    #       expect(app.exists?("acme_app").should be_false)
    #     end
    #   end

    # end

  end


end
