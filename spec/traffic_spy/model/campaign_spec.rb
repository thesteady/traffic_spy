require 'spec_helper'
require 'rspec'
require 'rack/test'

describe TrafficSpy::Campaign do

  include Rack::Test::Methods

  def app
    TrafficSpy::Campaign
  end

  describe "New Campaign Instance" do
    context "given required parameters for a new campaign instance" do
      it "creates a new campaign" do
        details = {:campaign_name => "button click campaign"}
        new_campaign = app.new(details)
        expect(new_campaign.name).to eq "button click campaign"
      end
    end
  end

end
