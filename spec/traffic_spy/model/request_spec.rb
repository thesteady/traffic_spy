require 'spec_helper'
require 'rspec'
require 'rack/test'
require 'json'

describe TrafficSpy::Request do

  include Rack::Test::Methods

  def app
    TrafficSpy::Request
  end


end
