# frozen_string_literal: true

require "delegate"
require_relative "error/argument_error_class"

module BarcodeValidation
  class Digit < DelegateClass(Integer)
    include Mixin::ValueObject

    INTEGER_CAST_ERRORS = [::ArgumentError, ::TypeError].freeze

    def initialize(input)
      value = Integer(input)
      raise ::ArgumentError unless (0..9).cover? value

      super(value)
    rescue *INTEGER_CAST_ERRORS
      raise Digit::ArgumentError, input
    end

    alias to_i __getobj__

    ArgumentError = Error::ArgumentErrorClass.new(self)
  end
end
