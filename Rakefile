require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'bump/tasks'

RSpec::Core::RakeTask.new(:spec)

RuboCop::RakeTask.new do |task|
  task.options = [ '--lint' ]
  task.fail_on_error = true
end

task default: [:rubocop, :spec]
