require "barcodevalidation/mixin"
require "barcodevalidation/error"
require "barcodevalidation/digit"
require "barcodevalidation/digit_sequence"
require "barcodevalidation/gtin"
require "barcodevalidation/version"

module BarcodeValidation
  def self.scan(input)
    GTIN.new(input).tap do |result|
      raise InvalidGTINError, input unless result.valid?
    end
  end

  class InvalidGTINError < ::ArgumentError
    include Error

    def initialize(input)
      super "Invalid GTIN #{input.inspect}"
    end
  end
end
