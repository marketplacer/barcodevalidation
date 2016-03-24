# This script sets up the common environment for the project
#
# Require this file using:
#
#     require File.expand_path("../config/boot.rb", __FILE__)
#
# This would work from any file located in the root of the project.
# For files that are nested within a subdirectory, use a relative path:
#
#     # From within foo/bar/baz.rb relative to the root of the project
#     require File.expand_path("../../../config/boot.rb", __FILE__)
#
# Then, to all RubyGems in the Gemfile available, use one of:
#
#   - require "bundler/setup"
#   - Bundler.setup
#
# To make only certain groups available, use:
#
#     Bundler.setup(:default, :ci)
require "pathname"
project_root = Pathname.new(__FILE__).parent.parent
ENV["BUNDLE_GEMFILE"] ||= (project_root + "Gemfile").to_s
require "bundler"
