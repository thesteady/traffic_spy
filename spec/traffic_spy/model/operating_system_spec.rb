require 'spec_helper'
require 'rspec'
require 'rack/test'

describe TrafficSpy::OperatingSystem do

  include Rack::Test::Methods

  def app
    TrafficSpy::OperatingSystem
  end

  # describe "New Instance" do
  #   context "given required parameters for a new instance" do
  #     it "creates a new OS instance" do
  #       details = {:name =>"Macintosh; Intel Mac OS X 10_8_2"}
  #       my_os = app.new(details)
  #       expect(my_os.name).to eq "Macintosh; Intel Mac OS X 10_8_2"
  #     end
  #   end
  # end

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

    describe ".new" do
      it "creates a new instance" do
        os = app.new(os_1)
        expect(os.name).to eq("Mac OSX")
      end
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

    describe ".find(input)" do
      before do
        @os_1 = app.new(os_1)
        @os_1_id = @os_1.save
        @os_2 = app.new(os_2)
        @os_2_id = @os_2.save
      end

      context "using id as parameter" do
        it "returns first record that matches given parameter" do
          expect(app.find(id: @os_1_id).name).to eq("Mac OSX")
        end
      end

      context "using name as parameter" do
        it "returns first record that matches given parameter" do
          name = @os_2.name
          expect(app.find(name: name).name).to eq("Windows")
        end
      end
    end

    describe "#exists?" do

      context "record exists in db" do
        it 'should return true' do
          os = app.new(os_1)
          os.save
          expect(os.exists?.should be_true)
        end
      end

      context "record does not exist in db" do
        it 'should return false' do
          os = app.new(os_2)
          expect(os.exists?.should be_false)
        end
      end
    end
  end

end
