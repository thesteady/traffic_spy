  module TrafficSpy

  if ENV["TRAFFIC_SPY_ENV"] == "test"
    database_path = 'trafficspy_test'
  elsif ENV["TRAFFIC_SPY_ENV"] == "development"
    database_path = 'trafficspy_development'
  else
    database_path = 'trafficspy_production'
  end

  DB = Sequel.postgres('trafficspy_development')

end

require 'traffic_spy/models/site'
require 'traffic_spy/models/browser'
require 'traffic_spy/models/campaign'
require 'traffic_spy/models/event'
require 'traffic_spy/models/operating_system'
require 'traffic_spy/models/request'
require 'traffic_spy/models/url_path'
require 'traffic_spy/models/campaign_event'
