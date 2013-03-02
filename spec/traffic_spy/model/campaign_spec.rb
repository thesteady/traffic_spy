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
        details = {:name => "button click campaign"}
        new_campaign = app.new(details)
        expect(new_campaign.name).to eq "button click campaign"
      end
    end
  end

  describe "Class method" do

    before do
      TrafficSpy::DB[:campaigns].delete
    end

    let(:c1) do
      {:name => "holiday_sale"}
    end

    let(:c2) do
      {:name => "labor_day_sale"}
    end

    describe ".count" do
      it  "returns 1 record" do
        campaign = app.new(c1)
        campaign.save
        expect(app.count).to eq(1)
      end
    end

    describe ".all" do
      it "returns 2 records" do
        app.new(c1).save
        app.new(c2).save
        expect(app.all.count).to eq(2)
      end
    end

    describe ".find(id)" do
      it "returns record with id of first saved url" do
        app.new(c1).save
        app.new(c2).save

        test_id = app.all.first.id
        expect(app.find(test_id).name).to eq("holiday_sale")
      end
    end

    describe ".find_by_name(name)"do
      it "returns campaign for the given name" do
        app.new(c1).save
        app.new(c2).save

        test_name = app.all.first.name
        expect(app.find_by_name(test_name).name).to eq("holiday_sale")
     end
    end

    describe ".exists?(url_name)" do

      context "record exists in db" do
        it 'should return true' do
          app.new(c1).save
          url = app.all.first

          expect(app.exists?(url.name).should be_true)
        end
      end

      context "record does not exist in db" do
        it 'should return false' do
          expect(app.exists?("valentines_day").should be_false)
        end
      end
    end
  end



end
