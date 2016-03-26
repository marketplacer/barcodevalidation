require "delegate"

module BarcodeValidation
  class Digit < DelegateClass(Integer)
    include Mixin::ValueObject

    def initialize(input)
      value = Integer(input)
      raise RangeError, "digits must be 0-9" unless (0..9).cover? value
      super(value)
    end
  end
end
