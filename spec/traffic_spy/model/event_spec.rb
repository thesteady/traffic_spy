require 'spec_helper'
require 'rspec'
require 'rack/test'

describe TrafficSpy::Event do

  include Rack::Test::Methods

  def app
    TrafficSpy::Event
  end

  describe "New Event Instance" do
    context "given required parameters for a new event instance" do
      it "creates a new event" do
        details = {:name => "log_in"}
        new_event = app.new(details)
        expect(new_event.name).to eq "log_in"
      end
    end
  end

  describe "Class method" do

    before do
      TrafficSpy::DB[:events].delete
    end

    let(:e1) do
      {:name => "sociallogin"}
    end

    let(:e2) do
      {:name => "log_in"}
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

    describe ".find(id)" do
      it "returns record with id of first saved e" do
        app.new(e1).save
        app.new(e2).save

        test_id = app.all.first.id
        expect(app.find(test_id).name).to eq("sociallogin")
      end
    end

    describe ".exists?(event_name)" do

      context "record exists in db" do
        it 'should return true' do
          app.new(e1).save
          event = app.all.first

          expect(app.exists?(event.name).should be_true)
        end
      end

      context "record does not exist in db" do
        it 'should return false' do
          expect(app.exists?("cancel_account").should be_false)
        end
      end

    end

  end

end
