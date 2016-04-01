require "forwardable"

module BarcodeValidation
  class DigitSequence < Array
    extend Forwardable
    include Mixin::ValueObject

    delegate to_s: :join
    delegate cast: "self.class"

    # Memoize constructor based on the integer value given
    def self.memoization_key(input, *)
      input.respond_to?(:join) ? input.join : input.to_s
    end

    def self.cast(input)
      input = input.to_s if input.is_a? Integer
      input = input.chars if input.is_a? String
      input
    end

    def initialize(values)
      values = cast(values)
      raise ArgumentError, values unless values.respond_to? :map
      super(values.map { |value| BarcodeValidation::Digit.new(value) })
    end

    def ==(other)
      case other
      when String, Numeric then super(self.class.new(other))
      else super
      end
    end

    %i(* + - drop first last reverse rotate slice shuffle
       take).each do |method_name|
      define_method method_name do |*args|
        super(*args).tap do |result|
          return DigitSequence.new(result) if result.is_a? Enumerable
        end
      end
    end

    ArgumentError = Error::ArgumentErrorClass.new(DigitSequence)
  end
end
