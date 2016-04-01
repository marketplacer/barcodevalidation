module BarcodeValidation
  module Mixin
    # Wraps #last as a CheckDigit
    module HasCheckDigit
      MODULUS = 10

      def check_digit
        GTIN::CheckDigit.new(last, expected: expected_check_digit)
      end

      private

      def expected_check_digit
        (MODULUS - weighted_checkable_digit_sum) % MODULUS
      end

      def weighted_checkable_digit_sum
        checkable_digits
          .zip([3, 1].cycle)
          .map { |l, r| l * r }
          .reduce(&:+)
      end

      def checkable_digits
        take(length - 1).reverse
      end
    end
  end
end
