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
        details = {:eventname => "log_in"}
        new_event = app.new(details)
        expect(new_event.name).to eq "log_in"
      end
    end
  end

end
