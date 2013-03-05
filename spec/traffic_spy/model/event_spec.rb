require 'spec_helper'
require 'rspec'
require 'rack/test'

describe TrafficSpy::Event do

  include Rack::Test::Methods

  def app
    TrafficSpy::Event
  end

  after do
    TrafficSpy::DB[:sites].delete
    TrafficSpy::DB[:requests].delete
    TrafficSpy::DB[:events].delete
    TrafficSpy::DB[:url_paths].delete
  end

  describe "Class method" do

    let(:e1) do
      {:name => "sociallogin", :site_id => 1}
    end

    let(:e2) do
      {:name => "log_in", :site_id => 2}
    end

    describe ".new" do
      it "creates a new instance" do
        event = app.new(e1)
        expect(event.name).to eq("sociallogin")
      end
    end

    describe ".count" do
      it  "returns 1 record" do
        event = app.new(e1)
        event.save
        expect(app.count).to eq(1)
      end
    end

    describe ".all" do
      it "returns 2 records" do
        app.new(e1).save
        app.new(e2).save
        expect(app.all.count).to eq(2)
      end
    end

    describe ".find" do

      before do
        @e1 = app.new(e1)
        @e1_id = @e1.save
        @e2 = app.new(e2)
        @e2_id = @e2.save
      end

      context "using id as parameter" do
        it "returns first record that matches given parameter" do
          expect(app.find({id: @e1_id}, {site_id: 1}).name).to eq("sociallogin")
        end
      end

      context "using name as parameter" do
        it "returns first record that matches given parameter" do
          name = @e2.name
          expect(app.find({name: name}, {site_id: 2}).name).to eq("log_in")
        end
      end
    end

    describe ".find_id" do
      context "event is in db" do
        it "returns the id for the provided event" do
          event = app.new(e1)
          event_id = event.save
          expect(event.find_id).to eq(event_id)
        end
      end

      context "event is not in db" do
        it "returns the id for a given path" do
          event = app.new(e1)
          expect(event.find_id).to eq(false)
        end
      end
    end

    describe ".find_all_by_site_id(site_id)" do
      it "returns an array of event objects belonging to site id" do
        app.new(e1).save
        app.new(e2).save

        expect(app.find_all_by_site_id(2).count).to eq 1
      end
    end

    describe ".exists?(event_name)" do
      context "record exists in db" do
        it 'should return true' do
          event = app.new(e1)
          event.save
          expect(event.exists?.should be_true)
        end
      end

      context "record does not exist in db" do
        it 'should return false' do
          event = app.new(e2)
          expect(event.exists?.should be_false)
        end
      end

    end

  end

end
