# frozen_string_literal: true

require "forwardable"
require_relative "error/argument_error_class"

module BarcodeValidation
  class DigitSequence < Array
    extend Forwardable
    include Adamantium::Flat
    include Mixin::ValueObject

    delegate to_s: :join
    delegate cast: "self.class"

    def self.cast(input)
      input = input.to_s if input.is_a? Integer
      input = input.chars if input.is_a? String
      input
    end

    def initialize(values)
      values = cast(values)
      raise ArgumentError, values unless values.respond_to? :map

      super(values.map { |value| BarcodeValidation::Digit.new(value) })
    end

    def ==(other)
      case other
      when String, Numeric then super(self.class.new(other))
      else super
      end
    end

    ArgumentError = Error::ArgumentErrorClass.new(DigitSequence)
  end
end
