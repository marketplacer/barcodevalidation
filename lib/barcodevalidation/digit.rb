require "delegate"

module BarcodeValidation
  class Digit < DelegateClass(Integer)
    include Mixin::ValueObject

    INTEGER_CAST_ERRORS = [::ArgumentError, ::TypeError].freeze

    # Memoize constructor based on the integer value given
    def self.memoization_key(input, *)
      Integer(input)
    rescue *INTEGER_CAST_ERRORS
      nil # the constructor will raise
    end

    def initialize(input)
      value = Integer(input)
      raise ::ArgumentError unless (0..9).cover? value
      super(value)
    rescue *INTEGER_CAST_ERRORS
      raise Digit::ArgumentError, input
    end

    ArgumentError = Error::ArgumentErrorClass.new(self)
  end
end
