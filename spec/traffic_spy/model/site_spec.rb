require 'spec_helper'
require 'rspec'
require 'rack/test'

describe TrafficSpy::Site do

  include Rack::Test::Methods

  def app
    TrafficSpy::Site
  end


  describe "Class method" do

    before do
      TrafficSpy::DB[:sites].delete
    end

    after do
      TrafficSpy::DB[:sites].delete
    end

    let(:site1) do
      {identifier: "jumpstartlab", rootUrl: "http://jumpstartlab.com"}
    end

    let(:site2) do
      {identifier: "espn", rootUrl: "http://espn.com" }
    end

    describe ".new" do
      it "creates new instance" do
        site = app.new(site1)
        site.save
        expect(site.identifier).to eq "jumpstartlab"
        expect(site.rootUrl).to eq 'http://jumpstartlab.com'
      end

    end

    describe ".count" do
      it  "returns 1 record" do
        site = app.new(site1)
        site.save
        expect(app.count).to eq(1)
      end
    end

    describe ".all" do
      it "returns 2 records" do
        app.new(site1).save
        app.new(site2).save
        expect(app.all.count).to eq(2)
      end
    end

    describe ".find" do

      before do
        @s1 = app.new(site1)
        @s1_id = @s1.save
        @s2 = app.new(site2)
        @s2_id = @s2.save
      end

      context "using id as parameter" do
        it "returns first record that matches given parameter" do
          expect(app.find(id: @s1_id).identifier).to eq("jumpstartlab")
        end
      end

      context "using identifier as parameter" do
        it "returns first record that matches given parameter" do
          identifier = @s2.identifier
          expect(app.find(identifier: identifier).identifier).to eq("espn")
        end
      end

      context "using rootUrl as parameter" do
        it "returns first record that matches given parameter" do
          rootUrl = @s2.rootUrl
          expect(app.find(rootUrl: rootUrl).rootUrl).to eq("http://espn.com")
        end
      end
    end

    describe "#exists?(identifier)" do

      context "record exists in db" do
        it 'should return true' do
           site = app.new(site1)
           site.save

          expect(site.exists?.should be_true)
        end
      end

      context "record does not exist in db" do
        it 'should return false' do
          site = app.new(site2)
          expect(site.exists?.should be_false)
        end
      end
    end

  end

end
