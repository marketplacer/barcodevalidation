require "forwardable"

module BarcodeValidation
  class DigitSequence < Array
    extend Forwardable
    include Mixin::ValueObject

    delegate to_s: :join

    def initialize(values)
      values = cast(values)
      raise TypeError, values unless values.respond_to? :map
      super(values.map { |value| BarcodeValidation::Digit.new(value) })
    end

    def ==(other)
      case other
      when String, Numeric then super(self.class.new(other))
      else super
      end
    end

    SEQUENCE_METHODS = %i(* + - drop first last reverse rotate slice
                          shuffle take).freeze

    SEQUENCE_METHODS.each do |method_name|
      define_method method_name do |*args|
        super(*args).tap do |result|
          return DigitSequence.new(result) if result.is_a? Enumerable
        end
      end
    end

    private

    def cast(input)
      input = input.to_s if input.is_a? Integer
      input = input.chars if input.is_a? String
      input
    end

    class TypeError < ::TypeError
      def initialize(input)
        super "unknown sequence type #{input.class}: #{input.inspect}"
      end
    end
  end
end
