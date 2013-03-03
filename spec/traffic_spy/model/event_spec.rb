require 'spec_helper'
require 'rspec'
require 'rack/test'

describe TrafficSpy::Event do

  include Rack::Test::Methods

  def app
    TrafficSpy::Event
  end

  describe "Class method" do

    before do
      TrafficSpy::DB[:events].delete
    end

    let(:e1) do
      {name: "sociallogin"}
    end

    let(:e2) do
      {name: "log_in"}
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
          expect(app.find(id: @e1_id).name).to eq("sociallogin")
        end
      end

      context "using name as parameter" do
        it "returns first record that matches given parameter" do
          name = @e2.name
          expect(app.find(name: name).name).to eq("log_in")
        end
      end
    end

    describe "#exists?(event_name)" do

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
