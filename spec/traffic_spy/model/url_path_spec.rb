require 'spec_helper'
require 'rspec'
require 'rack/test'

describe TrafficSpy::UrlPath do

  include Rack::Test::Methods

  def app
    TrafficSpy::UrlPath
  end

  describe "New Instance" do
    context "given required parameters for a new instance" do
      it "creates a new url path" do
        details_hash = {:path=>"http://jumpstartlab.com/blog/article1"}
        url = app.new(details_hash)
        expect(url.path).to eq "http://jumpstartlab.com/blog/article1"
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
        site = app.new(url1)
        site.save
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
