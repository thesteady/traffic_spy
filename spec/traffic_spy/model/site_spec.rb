require 'spec_helper'
require 'rspec'
require 'rack/test'

describe TrafficSpy::Site do

  include Rack::Test::Methods

  def app
    TrafficSpy::Site
  end

  describe "Creation" do
    context "given required parameters for a new instance" do
      it "creates a new site application" do
        data_hash = { :identifier => "jumpstartlab", 
                      :rootUrl => 'http://jumpstartlab.com'}
        jumpstartlab = TrafficSpy::Site.new(data_hash)

        expect(jumpstartlab.identifier).to eq "jumpstartlab"
        expect(jumpstartlab.rootUrl).to eq 'http://jumpstartlab.com'
      end
    end
  end

end
