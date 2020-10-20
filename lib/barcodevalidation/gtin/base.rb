require "forwardable"

module BarcodeValidation
  module GTIN
    class Base < BarcodeValidation::DigitSequence
      MODULUS = 10

      extend Forwardable

      attr_reader :input

      def initialize(input)
        @input = input

        super
      rescue BarcodeValidation::Error => e
        BarcodeValidation::InvalidGTIN.new(input, error: e)
      end

      def valid?
        valid_length == length && check_digit.valid?
      end

      def valid_length
        raise AbstractMethodError.new("Concrete classes must define #valid_length")
      end

      class AbstractMethodError < StandardError; end

      private

      def check_digit
        CheckDigit.new(last, expected: expected_check_digit)
      end

      def expected_check_digit
        (MODULUS - weighted_checkable_digit_sum) % MODULUS
      end

      def weighted_checkable_digit_sum
        checkable_digits
          .zip([3, 1].cycle)
          .map { |digit, factor| digit * factor }
          .reduce(&:+)
      end

      def checkable_digits
        take(length - 1).reverse.map(&:to_i)
      end
    end
  end
end
