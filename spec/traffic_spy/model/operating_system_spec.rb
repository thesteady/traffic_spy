require 'spec_helper'
require 'rspec'
require 'rack/test'

describe TrafficSpy::OperatingSystem do

  include Rack::Test::Methods

  def app
    TrafficSpy::OperatingSystem
  end

  describe "Class method" do

    let(:os1) do
      {:name => "Mac OSX"}
    end

    let(:os2) do
      {:name => "Windows"}
    end

    describe ".new" do
      it "creates a new instance" do
        os = app.new(os1)
        expect(os.name).to eq("Mac OSX")
      end
    end

    describe ".count" do
      it  "returns 1 record" do
        os = app.new(os1)
        os.save
        expect(app.count).to eq(1)
      end
    end

    describe ".all" do
      it "returns 2 records" do
        app.new(os1).save
        app.new(os2).save
        expect(app.all.count).to eq(2)
      end
    end

    describe ".find(input)" do
      before do
        @os1 = app.new(os1)
        @os1_id = @os1.save
        @os2 = app.new(os2)
        @os2_id = @os2.save
      end

      context "using id as parameter" do
        it "returns first record that matches given parameter" do
          expect(app.find(id: @os1_id).name).to eq("Mac OSX")
        end
      end

      context "using name as parameter" do
        it "returns first record that matches given parameter" do
          name = @os2.name
          expect(app.find(name: name).name).to eq("Windows")
        end
      end
    end

    describe ".find_id" do
      context "os is in db" do
        it "returns the id for the provided os" do
          os = app.new(os1)
          os_id = os.save
          expect(os.find_id).to eq(os_id)
        end
      end

      context "os is not in db" do
        it "returns the id for a given os" do
          os = app.new(os2)
          expect(os.find_id).to eq(false)
        end
      end
    end

    describe "#exists?" do

      context "record exists in db" do
        it 'should return true' do
          os = app.new(os1)
          os.save
          expect(os.exists?.should be_true)
        end
      end

      context "record does not exist in db" do
        it 'should return false' do
          os = app.new(os2)
          expect(os.exists?.should be_false)
        end
      end
    end
  end

end
