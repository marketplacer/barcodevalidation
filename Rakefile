require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new :spec

namespace :quality do
  RuboCop::RakeTask.new :rubocop
end

desc "Run all code quality tools"
task quality: %i[quality:rubocop]

desc "Run a full build"
task default: %i[spec quality]
