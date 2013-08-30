# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dronetrack/version'

Gem::Specification.new do |spec|
  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.add_dependency 'oauth2', '~> 0.9.2'
  spec.authors       = ["Andrey Belchikov"]
  spec.description   = %q{This is a simple ruby gem for integrating with the Dronetrack  API.}
  spec.files         = %w(LICENSE README.md Rakefile dronetrack.gemspec)
  spec.files        += Dir.glob("lib/**/*.rb")
  spec.files        += Dir.glob("spec/**/*")
  spec.homepage      = 'https://github.com/scottbarstow/ruby-dronetrack'
  spec.name          = 'dronetrack'
  spec.require_paths = ['lib']
  spec.required_rubygems_version = '>= 1.3.5'
  spec.summary       = %q{A Ruby wrapper for  Dronetrack  API.}
  spec.test_files    = Dir.glob("spec/**/*")
  spec.version       = Dronetrack::Version
end
