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
      {:identifier => "jumpstartlab", :rootUrl => "http://jumpstartlab.com"}
    end

    let(:site2) do
      {:identifier => "espn", :rootUrl => "http://espn.com" }
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

        puts "******************"
        puts app.all.inspect
        expect(app.all.count).to eq(2)
      end
    end

    describe ".find(id)" do
      it "returns record with id of 2" do
        sid_1 = app.new(site1).save
        sid_2 = app.new(site2).save

        expect(app.find(sid_1).identifier).to eq("jumpstartlab")
      end
    end

    describe ".find_by_rootUrl" do
      it "returns a record with site id, rootUrl, and identifier" do
      new_site = app.new(site1).save

      expect(app.find_by_rootUrl("http://jumpstartlab.com").id).to eq new_site
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
