module TrafficSpy

  # database_file = 'db/ideabox.sqlite3'

  # if ENV["IDEA_BOX_ENV"] == "test"
  #   database_file = 'db/ideabox-test.sqlite3'
  # end

  DB = Sequel.postgres('trafficspy', :host=>'localhost', :user=>'user', :password=>'password')

end

require 'traffic_spy/models/application'