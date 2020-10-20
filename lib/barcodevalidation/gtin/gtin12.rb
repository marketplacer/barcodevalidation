module BarcodeValidation
  module GTIN
    class GTIN12 < BarcodeValidation::GTIN::Base
      def valid_length
        12
      end
    end
  end
end
