module TrafficSpy

  if ENV["TRAFFIC_SPY_ENV"] == "test"
    database_path = 'trafficspy-test'
  end

  DB = Sequel.postgres('trafficspy')

end

require 'traffic_spy/models/site'
require 'traffic_spy/models/browser'
require 'traffic_spy/models/campaign'
require 'traffic_spy/models/event'
require 'traffic_spy/models/operating_system'
require 'traffic_spy/models/request'
require 'traffic_spy/models/url_path'
