require 'spec_helper'
require 'rspec'
require 'rack/test'

describe TrafficSpy::OperatingSystem do

  include Rack::Test::Methods

  def app
    TrafficSpy::OperatingSystem
  end

  describe "New Instance" do
    context "given required parameters for a new instance" do
      it "creates a new OS instance" do
        details = {:name =>"Macintosh; Intel Mac OS X 10_8_2"}
        my_os = app.new(details)
        expect(my_os.name).to eq "Macintosh; Intel Mac OS X 10_8_2"
      end
    end
  end

  describe "Class method" do

    before do
      TrafficSpy::DB[:operating_systems].delete
    end

    let(:os_1) do
      {:name => "Mac OSX"}
    end

    let(:os_2) do
      {:name => "Windows"}
    end

    describe ".count" do
      it  "returns 1 record" do
        os = app.new(os_1)
        os.save
        expect(app.count).to eq(1)
      end
    end

    describe ".all" do
      it "returns 2 records" do
        app.new(os_1).save
        app.new(os_2).save
        expect(app.all.count).to eq(2)
      end
    end

    describe ".find(id)" do
      it "returns record with id of first saved url" do
        app.new(os_1).save
        app.new(os_2).save

        test_id = app.all.first.id
        expect(app.find(test_id).name).to eq("Mac OSX")
      end
    end

    describe ".find_by_name(name)"do
      it "returns os for the given name" do
        app.new(os_1).save
        app.new(os_2).save

        test_name = app.all.first.name
        expect(app.find_by_name(test_name).name).to eq("Mac OSX")
     end
    end

    describe ".exists?(os_name)" do

      context "record exists in db" do
        it 'should return true' do
          app.new(os_1).save
          os = app.all.first

          expect(app.exists?(os.name).should be_true)
        end
      end

      context "record does not exist in db" do
        it 'should return false' do
          expect(app.exists?("Linux").should be_false)
        end
      end
    end
  end

end
