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
