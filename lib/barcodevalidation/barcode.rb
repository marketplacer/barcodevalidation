module BarcodeValidation
  module Barcode
    class CheckDigit < Digit
      include Mixin::ValueObject

      alias actual dup
      attr_reader :expected

      def initialize(actual, expected: nil)
        expected = actual if expected.nil?
        @expected = Digit.new(expected)
        super(Digit.new(actual))
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
