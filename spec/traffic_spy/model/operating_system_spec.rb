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
        details = {:os =>"Macintosh; Intel Mac OS X 10_8_2"}
        my_os = app.new(details)
        expect(my_os.operating_system).to eq "Macintosh; Intel Mac OS X 10_8_2"
      end
    end

  end

end
