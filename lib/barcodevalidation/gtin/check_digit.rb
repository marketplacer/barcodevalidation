module BarcodeValidation
  module GTIN
    class CheckDigit < DelegateClass(Digit)
      include Adamantium::Flat
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
