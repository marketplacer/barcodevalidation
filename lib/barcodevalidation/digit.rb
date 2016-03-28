require "delegate"

module BarcodeValidation
  class Digit < DelegateClass(Integer)
    include Mixin::ValueObject

    def initialize(input)
      value = Integer(input)
      raise ::ArgumentError unless (0..9).cover? value
      super(value)
    rescue ::ArgumentError
      raise Digit::ArgumentError, input
    end

    ArgumentError = Error::ArgumentErrorClass.new(self)
  end
end
