# frozen_string_literal: true

require "forwardable"
require_relative "invalid_gtin"
require_relative "gtin/base"
require_relative "gtin/check_digit"
require_relative "gtin/gtin8"
require_relative "gtin/gtin12"
require_relative "gtin/gtin13"
require_relative "gtin/gtin14"

module BarcodeValidation
  module GTIN
    def self.new(input)
      module_eval("GTIN#{input.to_s.size}", __FILE__, __LINE__).new(input)
    rescue NameError => e
      BarcodeValidation::InvalidGTIN.new(input, error: e)
    end
  end
end
