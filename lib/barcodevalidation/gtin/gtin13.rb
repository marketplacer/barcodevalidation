module BarcodeValidation
  module GTIN
    class GTIN13 < BarcodeValidation::GTIN::Base
      def valid_length
        13
      end
    end
  end
end
