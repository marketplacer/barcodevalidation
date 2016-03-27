module BarcodeValidation
  module Errors
    class InvalidGTINError < ::ArgumentError
      def initialize(input)
        super "invalid GTIN '#{input}'"
      end
    end
  end
end
