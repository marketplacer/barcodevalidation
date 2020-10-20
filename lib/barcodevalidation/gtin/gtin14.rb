# frozen_string_literal: true

module BarcodeValidation
  module GTIN
    class GTIN14 < BarcodeValidation::GTIN::Base
      def valid_length
        14
      end
    end
  end
end
