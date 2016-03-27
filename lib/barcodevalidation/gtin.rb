require "forwardable"

module BarcodeValidation
  class GTIN < BarcodeValidation::DigitSequence
    extend Forwardable
    include Mixin::HasCheckDigit

    delegate valid?: :check_digit

    class CheckDigit < Digit
      include Mixin::ValueObject

      attr_reader :actual, :expected

      def initialize(actual, expected: nil)
        expected = actual if expected.nil?
        @expected = Digit.new(expected)
        @actual = Digit.new(actual)
        super(@actual)
      end

      def valid?
        actual == expected
      end

      def inspect
        return super if valid?
        "#<#{self.class}(#{actual}) invalid: expected #{expected}>"
      end
    end
  end
end