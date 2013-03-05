require 'spec_helper'
require 'rspec'
require 'rack/test'


describe TrafficSpy::UrlPath do

  include Rack::Test::Methods

  def app
    TrafficSpy::UrlPath
  end

  before do
    TrafficSpy::DB[:sites].delete
    TrafficSpy::DB[:requests].delete
    TrafficSpy::DB[:events].delete
    TrafficSpy::DB[:url_paths].delete
  end

  describe "Class method" do

    let(:url1) do
      {path: "/blog", site_id: 1}
    end

    let(:url2) do
      {path: "/about_us", site_id: 2}
    end

    describe ".new" do
      it "creates a new instance" do
        url = app.new(url1)
        url.save
        expect(url.path).to eq "/blog"
      end
    end

    describe ".count" do
      it  "returns 1 record" do
        app.new(url1).save
        expect(app.count).to eq(1)
      end
    end

    describe ".all" do
      it "returns 2 records" do
        app.new(url1).save
        app.new(url2).save
        expect(app.all.count).to eq(2)
      end
    end

    describe ".find" do

      before do
        @url1 = app.new(url1)
        @url1_id = @url1.save
        @url2 = app.new(url2)
        @url2_id = @url2.save
      end

      context "using id as parameter" do
        it "returns first record that matches given parameter" do
          expect(app.find(id: @url1_id).path).to eq("/blog")
        end
      end

      context "using name as parameter" do
        it "returns first record that matches given parameter" do
          path = @url2.path
          expect(app.find(path: path).path).to eq("/about_us")
        end
      end
    end

    describe ".find_id" do
      context "url is in db" do
        it "returns the id for the provided path" do
          u1 = app.new(url1)
          u1_id = u1.save
          expect(u1.find_id).to eq(u1_id)
        end
      end

      context "url is not in db" do
        it "returns the id for a given path" do
          u1 = app.new(url1)
          expect(u1.find_id).to eq(false)
        end
      end
    end

    describe ".exists?(url_path)" do

      context "record exists in db" do
        it 'should return true' do
          url = app.new(url1)
          url.save
          expect(url.exists?.should be_true)
        end
      end

      context "record does not exist in db" do
        it 'should return false' do
          url = app.new(url2)
          expect(url.exists?.should be_false)
        end
      end
    end

    describe ".url_response_times" do

      before do
        site1 = TrafficSpy::Site.new({:identifier=>"jumpstartlab", :rootUrl => "http://jumpstartlab.com"})
        site1.save

        TrafficSpy::RequestParser.new(Payload.sample2).create_request
        TrafficSpy::RequestParser.new(Payload.sample3).create_request
        TrafficSpy::RequestParser.new(Payload.sample4).create_request

        @urlpath = TrafficSpy::UrlPath.find(path: "http://jumpstartlab.com/blog")
      end

      it 'should return hash of url ids and response times' do
        results = app.url_response_times(@urlpath)
        expect(results.last[1]).to eq(20)
      end
    end

    # describe ".find_all_by_site_id(site_id)" do
    #   context "when site_id exists" do
    #     it "returns an array of url path IDs belonging to the site_id" do
    #       # site1 = {:identifier=>"hey", :rootUrl => "http://hey.com"}
    #       # site2 = {:identifier => "bye", :rootUrl => "http://bye.com"}
    #       # TrafficSpy::Site.new(site1).save
    #       # TrafficSpy::Site.new(site2).save

    #       # url_path_1 = app.new(:path=>"http://hey.com/news").save
    #       # url_path_1.stub(:site_id).and_returns(site1.id)
    #       # url_path_2 = app.new(:path =>"http://hey.com/sales").save
    #       # url_path_2.stub(:site_id).and_returns(site1.id)
    #       # url_path_3 = app.new(:path =>url3 = "http://bye.com/news").save
    #       # url_path_3.stub(:site_id).and_returns(site2.id)


    #       # site_id = TrafficSpy::Site.find_by_identifier("hey").id

    #       # expect(app.find_all_by_site_id(site_id).count).to eq 2
    #       pending
    #     end
    #   end
    # end
  end



end
