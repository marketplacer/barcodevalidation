require "forwardable"

module BarcodeValidation
  class GTIN < BarcodeValidation::DigitSequence
    extend Forwardable
    include Mixin::HasCheckDigit

    VALID_LENGTHS = [8, 12, 13, 14].freeze

    def self.new(input)
      super
    rescue BarcodeValidation::Error => e
      InvalidGTIN.new(input, error: e)
    end

    def valid?
      VALID_LENGTHS.include?(length) && check_digit.valid?
    end

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
