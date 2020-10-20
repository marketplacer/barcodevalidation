# frozen_string_literal: true

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
        raise AbstractMethodError, "Concrete classes must define #valid_length"
      end

      class AbstractMethodError < StandardError; end

      def to_all_valid
        [
          to_gtin_8,
          to_gtin_12,
          to_gtin_13,
          to_gtin_14,
        ].select(&:valid?)
      end

      def to_gtin_8
        is_a?(GTIN8) ? self : transcode_to(GTIN8)
      end

      def to_gtin_12
        is_a?(GTIN12) ? self : transcode_to(GTIN12)
      end

      def to_gtin_13
        is_a?(GTIN13) ? self : transcode_to(GTIN13)
      end

      def to_gtin_14
        is_a?(GTIN14) ? self : transcode_to(GTIN14)
      end

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

      # Instantiates the given class with the string value of this instance
      # with any leading zeros stripped out, and then zero-padded up to the
      # valid length of the given class. If the resulting string is <> the
      # valid length of the target format, the returned object will be a
      # BarcodeValidation::InvalidGTIN with valid? = false and a meaningful
      # error message.
      def transcode_to(klass)
        gtin = klass.new(format("%0#{klass.new(nil).valid_length}d", to_s.gsub(/^0+/, "")))

        if gtin.valid?
          gtin
        else
          BarcodeValidation::InvalidGTIN.new(
            input,
            error: klass::ConversionError.new(klass).exception(input),
          )
        end
      end

      ConversionError = Error::ArgumentErrorClass.new(self)
    end
  end
end
