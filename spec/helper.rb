require 'simplecov'
require 'coveralls'
require 'yaml'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

$config = YAML.load_file(File.expand_path('../config.yml', __FILE__))

require 'dronetrack'
require 'rspec'
require 'rspec/autorun'
require_relative './auth'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end


RSpec.configure do |conf|
  include Dronetrack
end

