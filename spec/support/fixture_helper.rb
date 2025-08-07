# frozen_string_literal: true

require "pathname"

FIXTURES_PATH = Pathname.new(__FILE__).parent.parent / "fixtures"

fixture_helper = Module.new do
  def fixture_data(path)
    fixture_file(path).read.split("\n")
  end

  def fixture_file(path)
    FIXTURES_PATH / path
  end
end

RSpec.configure { |c| c.include fixture_helper }
