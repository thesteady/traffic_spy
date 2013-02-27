# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'traffic_spy/version'

Gem::Specification.new do |gem|
  gem.name          = "traffic_spy"
  gem.version       = TrafficSpy::VERSION
  gem.authors       = ["Kareem Grant", "Laura Steadman"]
  gem.email         = ["lauramsteadman@gmail.com"]
  gem.description   = %q{TrafficSpy project for gSchool 2013.}
  gem.summary       = %q{This is the TrafficSpy project.}
  gem.homepage      = "https://github.com/thesteady/traffic_spy"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency('rspec', '2.13.0')

   gem.add_dependency('sinatra', '1.3.5')
  # #gem.add_dependency('sql', '')
end
