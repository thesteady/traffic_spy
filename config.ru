current_path = File.expand_path('lib')
$LOAD_PATH.push(current_path) unless $LOAD_PATH.include?($LOAD_PATH)
Bundler.require

require 'traffic_spy'
run TrafficSpy::Router