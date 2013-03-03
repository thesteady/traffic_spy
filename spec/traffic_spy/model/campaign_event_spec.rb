require 'spec_helper'
require 'rspec'
require 'rack/test'

describe TrafficSpy::CampaignEvent do

  include Rack::Test::Methods

  def app
    TrafficSpy::CampaignEvent
  end

  describe "Class method" do

    before do
      TrafficSpy::DB[:campaign_events].delete
    end

    let(:ce1) do
      {:campaign_id => 1, :event_id => 2}
    end

    let(:ce2) do
      {:campaign_id => 2, :event_id => 3}
    end
    let(:ce3) do
      {:campaign_id => 1, :event_id => 3}
    end

    describe ".count" do
      it  "returns 1 record" do
        campaign = app.new(ce1)
        campaign.save
        expect(app.count).to eq(1)
      end
    end

    describe ".all" do
      it "returns 3 records" do
        app.new(ce1).save
        app.new(ce2).save
        app.new(ce3).save
        expect(app.all.count).to eq(3)
      end
    end

    describe ".find_by_campaign_id(id)" do
      it "returns records associated with provided campaign_id" do
        app.new(ce1).save
        app.new(ce2).save
        app.new(ce3).save

        expect(app.find_by_campaign_id(1).count).to eq(2)
      end
    end

    describe ".find_by_event_id(id)" do
      it "returns records associated with provided event_id" do
        app.new(ce1).save
        app.new(ce2).save
        app.new(ce3).save

        expect(app.find_by_event_id(3).count).to eq(2)
      end
    end
  end



end
