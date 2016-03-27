require "delegate"

module BarcodeValidation
  class Digit < DelegateClass(Integer)
    include Mixin::ValueObject

    def initialize(input)
      value = cast(input)
      raise RangeError, "digits must be 0-9" unless (0..9).cover? value
      super(value)
    end

    def cast(input)
      Integer(input)
    rescue ArgumentError => e
      e.message.gsub!("Integer", "BarcodeValidation::Digit")
      raise e
    end
  end
end
