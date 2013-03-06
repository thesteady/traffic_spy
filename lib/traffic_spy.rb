require 'sinatra/base'
require 'sequel'

ENV["TRAFFIC_SPY_ENV"] = "development"

require 'traffic_spy/models/base'

require 'traffic_spy/models/request_parser'
require 'traffic_spy/models/site'
require 'traffic_spy/models/request'
require 'traffic_spy/models/event'
require 'traffic_spy/models/campaign'
require 'traffic_spy/models/browser'
require 'traffic_spy/models/operating_system'
require 'traffic_spy/models/url_path'
require 'traffic_spy/models/site_summary'
require 'traffic_spy/router'

require 'traffic_spy/version'
require 'traffic_spy/router'


module TrafficSpy

end
