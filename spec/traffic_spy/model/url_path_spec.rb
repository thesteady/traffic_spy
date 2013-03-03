require 'spec_helper'
require 'rspec'
require 'rack/test'

describe TrafficSpy::UrlPath do

  include Rack::Test::Methods

  def app
    TrafficSpy::UrlPath
  end

  # describe "New Instance" do
  #   context "given required parameters for a new instance" do
  #     it "creates a new url path" do
  #       details_hash = {:path=>"http://jumpstartlab.com/blog/article1"}
  #       url = app.new(details_hash)
  #       expect(url.path).to eq "http://jumpstartlab.com/blog/article1"
  #     end
  #   end
  # end

  # describe "new instance" do
  #   context "given a new url_path" do
  #     it "parses it properly and stores with a new key value" do
  #       pending
  #     end
  #   end
  # end

  # describe "new instance" do
  #   context "given an existing url_path" do
  #     it "assigns the exisiting key value" do
  #       pending
  #     end
  #   end
  # end

  describe "Class method" do

    before do
      TrafficSpy::DB[:url_paths].delete
    end

    let(:url1) do
      {path: "/blog"}
    end

    let(:url2) do
      {path: "/about_us"}
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

  end

end
