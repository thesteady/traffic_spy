require 'spec_helper'
require 'rspec'
require 'rack/test'

describe TrafficSpy::Browser do

  include Rack::Test::Methods

  def app
    TrafficSpy::Browser
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

    describe "new" do
      it "should create new instance" do
        browser = app.new(b1)
        expect(browser.name).to eq("Mozilla")
      end
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

    describe ".find" do

      before do
        @b1 = app.new(b1)
        @b1_id = @b1.save
        @b2 = app.new(b2)
        @b2_id = @b2.save
      end

      context "using id as parameter" do
        it "returns first record that matches given parameter" do
          expect(app.find(id: @b1_id).name).to eq("Mozilla")
        end
      end

      context "using name as parameter" do
        it "returns first record that matches given parameter" do
          name = @b2.name
          expect(app.find(name: name).name).to eq("Firefox")
        end
      end
    end

    describe ".find_id" do
      context "browser name is in db" do
        it "returns the id for the provided path" do
          browser = app.new(b1)
          browser_id = browser.save
          expect(browser.find_id).to eq(browser_id)
        end
      end

      context "browser name is not in db" do
        it "returns the id for a given path" do
          browser = app.new(b2)
          expect(browser.find_id).to eq(false)
        end
      end
    end


    describe "#exists?" do

      context "record exists in db" do
        it 'should return true' do
          browser = app.new(b1)
          browser.save

          expect(browser.exists?.should be_true)
        end
      end

      context "record does not exist in db" do
        it 'should return false' do
          browser = app.new(b2)
          expect(browser.exists?.should be_false)
        end
      end
    end
  end

end
