source "https://rubygems.org"

# Add runtime dependencies from RubyGem specification
gemspec

# The interactive console at bin/console, used during development
gem "pry", group: %i[console spec]

group :rake do
  # Task runner
  gem "rake", "~> 12"

  # Static analysis for Ruby
  gem "rubocop", "~> 0.58", group: :rubocop

  group :spec do
    # Spec runner, DSL, matchers, and mocking framework all in one
    gem "rspec", "~> 3"

    # RSpec its syntax
    gem "rspec-its", require: "rspec/its"
  end
end
