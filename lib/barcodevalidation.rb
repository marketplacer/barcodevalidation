# frozen_string_literal: true

require "barcodevalidation/mixin"
require "barcodevalidation/error"
require "barcodevalidation/digit"
require "barcodevalidation/digit_sequence"
require "barcodevalidation/gtin"
require "barcodevalidation/invalid_gtin"
require "barcodevalidation/version"

module BarcodeValidation
  class << self
    def scan(input)
      GTIN.new(sanitize(input))
    end

    def scan!(input)
      scan(input).tap do |result|
        raise InvalidGTINError, input unless result.valid?
      end
    end

    private

    # Strips punctuation
    def sanitize(input)
      return input.gsub(/(\s|[-_])/, "") if input.respond_to? :gsub

      input
    end
  end

  class InvalidGTINError < ::ArgumentError
    include Error

    def initialize(input)
      super "Invalid GTIN #{input.inspect}"
    end
  end
end
