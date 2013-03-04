require 'spec_helper'
require 'rspec'
require 'rack/test'


describe TrafficSpy::UrlPath do

  include Rack::Test::Methods

  def app
    TrafficSpy::UrlPath
  end

  describe "New Instance" do
    before do
      TrafficSpy::DB[:url_paths].delete
    end

    context "given required parameters for a new instance" do
      it "creates a new url path" do
        details_hash = {:path=>"http://jumpstartlab.com/blog/article1"}
        url = app.new(details_hash)
        expect(url.path).to eq "http://jumpstartlab.com/blog/article1"
      end
    end

    context "given a new url_path" do
      it "stores with a new key value" do
        details_hash = {:path=>"http://jumpstartlab.com/blog/article1"}
        url = app.new(details_hash).save
        expect(url.class).to eq Fixnum
      end
    end

    context "given an existing url_path" do
      it "assigns the exisiting url_path_id" do
        site1 = {:path=>"http://jumpstartlab.com/blog/article1"}
        site2 = {:path=>"http://jumpstartlab.com/blog/article1"}
        new_site1 = app.new(site1).save
        new_site2 = app.new(site2).save
        expect(new_site1).to eq new_site2
        #need to implement a method to check for it already in the class (in save?)kareem may be doing this already
      end
    end
  end

  describe "Class method" do

    before do
      TrafficSpy::DB[:url_paths].delete
    end

    let(:url1) do
      {:path => "/blog"}
    end

    let(:url2) do
      {:path => "/about_us"}
    end

    describe ".count" do
      it  "returns 1 record" do
        url = app.new(url1)
        url.save
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

    describe ".find(id)" do
      it "returns record with id of first saved url" do
        app.new(url1).save
        app.new(url2).save

        test_id = app.all.first.id
        expect(app.find(test_id).path).to eq("/blog")
      end
    end

    describe ".find_by_path(path)"do
      it "returns record id for the path" do
        app.new(url1).save
        app.new(url2).save

        test_name = app.all.first.path
        expect(app.find_by_path(test_name).path).to eq("/blog")
     end
    end

    describe ".find_all_by_site_id(site_id)" do
      context "when site_id exists" do
        it "returns an array of url path IDs belonging to the site_id" do
          # site1 = {:identifier=>"hey", :rootUrl => "http://hey.com"}
          # site2 = {:identifier => "bye", :rootUrl => "http://bye.com"}
          # TrafficSpy::Site.new(site1).save
          # TrafficSpy::Site.new(site2).save

          # url_path_1 = app.new(:path=>"http://hey.com/news").save
          # url_path_1.stub(:site_id).and_returns(site1.id)
          # url_path_2 = app.new(:path =>"http://hey.com/sales").save
          # url_path_2.stub(:site_id).and_returns(site1.id)
          # url_path_3 = app.new(:path =>url3 = "http://bye.com/news").save
          # url_path_3.stub(:site_id).and_returns(site2.id)


          # site_id = TrafficSpy::Site.find_by_identifier("hey").id

          # expect(app.find_all_by_site_id(site_id).count).to eq 2
          pending
        end
      end
    end

    describe ".exists?(url_path)" do

      context "record exists in db" do
        it 'should return true' do
          app.new(url1).save
          url = app.all.first

          expect(app.exists?(url.path).should be_true)
        end
      end

      context "record does not exist in db" do
        it 'should return false' do
          expect(app.exists?("/help").should be_false)
        end
      end

    end

  end

end
