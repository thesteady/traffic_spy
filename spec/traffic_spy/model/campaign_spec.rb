require 'spec_helper'
require 'rspec'
require 'rack/test'

describe TrafficSpy::Campaign do

  include Rack::Test::Methods

  def app
    TrafficSpy::Campaign
  end

  # describe "New Campaign Instance" do
  #   context "given required parameters for a new campaign instance" do
  #     it "creates a new campaign" do
  #       details = {:name => "button click campaign"}
  #       new_campaign = app.new(details)
  #       expect(new_campaign.name).to eq "button click campaign"
  #     end
  #   end
  # end

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

    describe ".new" do
      it "creates a new instance" do
        campaign = app.new(c1)
        expect(campaign.name).to eq("holiday_sale")
      end
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

    describe ".find(input)" do

      before do
        @c1 = app.new(c1)
        @c1_id = @c1.save
        @c2 = app.new(c2)
        @c2_id = @c2.save
      end

      context "using id as parameter" do
        it "returns first record that matches given parameter" do
          expect(app.find(id: @c1_id).name).to eq("holiday_sale")
        end
      end

      context "using name as parameter" do
        it "returns first record that matches given parameter" do
          name = @c2.name
          expect(app.find(name: name).name).to eq("labor_day_sale")
        end
      end
    end


    describe "#exists?" do

      context "record exists in db" do
        it 'should return true' do
          campaign = app.new(c1)
          campaign.save
          expect(campaign.exists?.should be_true)
        end
      end

      context "record does not exist in db" do
        it 'should return false' do
          campaign = app.new(c2)
          expect(campaign.exists?.should be_false)
        end
      end
    end
  end



end
