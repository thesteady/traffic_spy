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
        details = {:browser => "Mozilla/5.0"}
        my_browser = app.new(details)
        expect(my_browser.browser).to eq "Mozilla/5.0"
      end
    end

  end

end
