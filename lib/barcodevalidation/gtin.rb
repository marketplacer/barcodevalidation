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
    class << self
      attr_accessor :gtin_classes

      def new(input)
        (class_for_input(input) || BarcodeValidation::InvalidGTIN).new(input)
      end

      private

      def class_for_input(input)
        input = input.to_s.freeze
        gtin_classes.find { |klass| klass.handles?(input) }
      end
    end
    self.gtin_classes = [GTIN8, GTIN12, GTIN13, GTIN14]
  end
end
