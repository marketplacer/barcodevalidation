require "rubocop/rake_task"

namespace :quality do
  RuboCop::RakeTask.new :rubocop
end

desc "Run all code quality tools"
task quality: %i(quality:rubocop)

desc "Run a full build"
task default: %i(quality)
