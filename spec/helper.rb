require 'simplecov'
require 'coveralls'
require 'yaml'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

require 'dronetrack'
require 'rspec'
require 'rspec/autorun'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end


RSpec.configure do |conf|
  include Dronetrack
end

$config = YAML.load_file(File.expand_path('../config.yml', __FILE__))
