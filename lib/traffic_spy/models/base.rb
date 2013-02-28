module TrafficSpy

  # database_file = 'db/ideabox.sqlite3'

  # if ENV["IDEA_BOX_ENV"] == "test"
  #   database_file = 'db/ideabox-test.sqlite3'
  # end
  
  if ENV["TRAFFIC_SPY_ENV"] == "test"
    database_path = 'trafficspy-test'
  end

  DB = Sequel.postgres('trafficspy', 
                      :host=>'localhost',
                      :user=>'user',
                      :password=>'password'
                      )

end

require 'traffic_spy/models/site'
