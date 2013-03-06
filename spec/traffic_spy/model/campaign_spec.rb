require 'spec_helper'
require 'rspec'
require 'rack/test'

describe TrafficSpy::Campaign do

  include Rack::Test::Methods

  def app
    TrafficSpy::Campaign
  end

  describe "Class method" do
    before do
        @site1 = TrafficSpy::Site.new(identifier: 'jumpstartlab', rootUrl: 'http://jumpstartlab.com').save
        @site2 = TrafficSpy::Site.new(identifier: 'otter', rootUrl: 'http://otter.com').save
        @site_id1 = TrafficSpy::Site.find(identifier: 'jumpstartlab').id
        @site_id2 = TrafficSpy::Site.find(identifier: 'otter').id
    end

    let(:input1) do
      {:identifier=> 'jumpstartlab', :name=>'holiday_sale', :site_id=>@site_id1}
    end

    let(:input2) do
      {:identifier=> 'otter', :name=>'labor_day_sale', :site_id=>@site_id2}
    end

    describe ".new" do
      it "creates a new instance" do
        campaign = app.new(input1)
        site_id = @site1
        expect(campaign.name).to eq("holiday_sale")
      end
    end

    describe ".count" do
      it  "returns 1 record" do
        app.new(input1).save
        expect(app.count).to eq(1)
      end
    end

    describe ".all" do
      it "returns 2 records" do
        app.new(input1).save
        app.new(input2).save
        all_records = app.all

        expect(app.all.count).to eq(2)
      end
    end

    describe ".find(input)" do

      before do
        @c1 = app.new(input1)
        @c1_id = @c1.save
        @c2 = app.new(input2)
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
          campaign = app.new(input1)
          campaign.save
          expect(campaign.exists?.should be_true)
        end
      end

      context "record does not exist in db" do
        it 'should return false' do
          campaign = app.new(input2)
          expect(campaign.exists?.should be_false)
        end
      end
    end
  end



end
