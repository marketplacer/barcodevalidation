require "barcodevalidation/mixin"
require "barcodevalidation/error"
require "barcodevalidation/digit"
require "barcodevalidation/digit_sequence"
require "barcodevalidation/gtin"
require "barcodevalidation/invalid_gtin"
require "barcodevalidation/version"

module BarcodeValidation
  def self.scan(input)
    GTIN.new(input)
  end

  def self.scan!(input)
    scan(input).tap do |result|
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
