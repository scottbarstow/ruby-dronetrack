require 'bundler'
Bundler::GemHelper.install_tasks

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default => :spec
task :test => :spec

namespace :doc do
  require 'rdoc/task'
  require File.expand_path('../lib/dronetrack/version', __FILE__)
  RDoc::Task.new do |rdoc|
    rdoc.rdoc_dir = 'rdoc'
    rdoc.title = "dronetrack #{Dronetrack::Version}"
    rdoc.main = 'README.md'
    rdoc.rdoc_files.include('README.md', 'LICENSE', 'lib/**/*.rb')
  end
end
