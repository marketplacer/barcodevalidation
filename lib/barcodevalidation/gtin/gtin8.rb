# frozen_string_literal: true

module BarcodeValidation
  module GTIN
    class GTIN8 < BarcodeValidation::GTIN::Base
      def valid_length
        8
      end
    end
  end
end
