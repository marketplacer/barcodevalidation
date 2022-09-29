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

      # Does this class (potentially) handle a GTIN that matches the input?
      # Subclasses can choose to implement their own logic. The default is to look at +VALID_LENGTH+ and use that to match the length of the input the class handles.
      def self.handles?(input)
        return false unless const_defined?(:VALID_LENGTH)

        input.length == self::VALID_LENGTH
      end

      # Upon inheritance, register the subclass so users of the library can dynamically add more GTINs in their own code.
      def self.inherited(subclass)
        BarcodeValidation::GTIN.append_gtin_class(subclass)
      end

      # Ensure this class is earlier in the GTIN classes list than +other_gtin_class+ and thus will get asked earlier if it handles a GTIN.
      def self.prioritize_before(other_gtin_class)
        raise ArgumentError, "The class you want to prioritize before is not a registered prioritized GTIN class." unless GTIN.gtin_class?(other_gtin_class)

        GTIN.reprioritize_before(self, other_gtin_class)
      end

      # This class is abstract and should not be included in the list of GTIN classes that actually implement a GTIN.
      def self.abstract_class
        BarcodeValidation::GTIN.remove_gtin_class(self)
      end

      # GTIN::Base is an abstract class. See GTIN8/12/13/14 for implementations of actual GTINs.
      abstract_class

      def valid?
        valid_length == length && check_digit.valid?
      end

      def valid_length
        raise(AbstractMethodError, "Concrete classes must define the VALID_LENGTH constant") unless self.class.const_defined?(:VALID_LENGTH)

        self.class::VALID_LENGTH
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

      def check_digit
        CheckDigit.new(last, expected: expected_check_digit)
      end

      private

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
        gtin = klass.new(format("%0#{klass::VALID_LENGTH}d", to_s.gsub(/^0+/, "")))

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
