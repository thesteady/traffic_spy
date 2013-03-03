require 'spec_helper'
require 'rspec'
require 'rack/test'

describe TrafficSpy::Browser do

  include Rack::Test::Methods

  def app
    TrafficSpy::Browser
  end

  describe "New Instance" do
    context "given required parameters for a new instance" do
      it "creates a new browser instance" do
        details = {:name => "Mozilla/5.0"}
        my_browser = app.new(details)
        expect(my_browser.name).to eq "Mozilla/5.0"
      end
    end
  end

  describe "Class method" do

    before do
      TrafficSpy::DB[:browsers].delete
    end

    let(:b1) do
      {:name => "Mozilla"}
    end

    let(:b2) do
      {:name => "Firefox"}
    end

    describe ".count" do
      it  "returns 1 record" do
        browser = app.new(b1)
        browser.save
        expect(app.count).to eq(1)
      end
    end

    describe ".all" do
      it "returns 2 records" do
        app.new(b1).save
        app.new(b2).save
        expect(app.all.count).to eq(2)
      end
    end

    describe ".find(id)" do
      it "returns browser for provided id " do
        app.new(b1).save
        app.new(b2).save

        test_id = app.all.first.id
        expect(app.find(test_id).name).to eq("Mozilla")
      end
    end

    describe ".find_by_name(name)"do
      it "returns browser for provided name" do
        app.new(b1).save
        app.new(b2).save

        test_name = app.all.first.name
        expect(app.find_by_name(test_name).name).to eq("Mozilla")
     end
    end

    describe ".exists?(browser_name)" do

      context "record exists in db" do
        it 'should return true' do
          app.new(b1).save
          browser = app.all.first

          expect(app.exists?(browser.name).should be_true)
        end
      end

      context "record does not exist in db" do
        it 'should return false' do
          expect(app.exists?("Opera").should be_false)
        end
      end
    end
  end

end
