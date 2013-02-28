require 'spec_helper'
require 'rspec'
require 'rack/test'

describe TrafficSpy::UrlPath do

  include Rack::Test::Methods

  def app
    TrafficSpy::UrlPath
  end

  describe "New Instance" do
    context "given required parameters for a new instance" do
      it "creates a new url path" do
        details_hash = {:url=>"http://jumpstartlab.com/blog/article1"}
        url = app.new(details_hash)
        expect(url.url_path).to eq "http://jumpstartlab.com/blog/article1"
      end
    end

  end

end
