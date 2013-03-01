require 'spec_helper'
require 'rspec'
require 'rack/test'

describe TrafficSpy::Site do

  include Rack::Test::Methods

  def app
    TrafficSpy::Site
  end

  describe "Creation" do

    context "given required parameters for a new instance" do
      it "creates a new site application" do
        data_hash = { :identifier => "jumpstartlab",
                      :rootUrl => 'http://jumpstartlab.com'}
        jumpstartlab = app.new(data_hash)

        expect(jumpstartlab.identifier).to eq "jumpstartlab"
        expect(jumpstartlab.rootUrl).to eq 'http://jumpstartlab.com'
      end
    end
  end

  describe "Class method" do

    before do
      TrafficSpy::DB[:sites].delete
    end

    let(:site1) do
      {:identifier => "jumpstartlab", :rootUrl => "http://jumpstartlab.com"}
    end

    let(:site2) do
      {:identifier => "espn", :rootUrl => "http://espn.com" }
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

    describe ".find(id)" do
      it "returns record with id of 2" do
        app.new(site1).save
        app.new(site2).save

        test_id = app.all.first.id
        puts test_id
        expect(app.find(test_id).identifier).to eq("jumpstartlab")
      end
    end

    describe ".exists?(identifier)" do

      context "record exists in db" do
        it 'should return true' do
          app.new(site1).save
          site = app.all.first

          expect(app.exists?(site.identifier).should be_true)
        end
      end

      context "record does not exist in db" do
        it 'should return false' do
          expect(app.exists?("acme_app").should be_false)
        end
      end

    end

  end

end
