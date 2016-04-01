require "forwardable"

module BarcodeValidation
  module Error
    class ArgumentErrorClass < ::ArgumentError
      include BarcodeValidation::Error
      extend Forwardable

      delegate klass: "self.class"

      def self.new(klass)
        Class.new(self) { define_singleton_method(:klass) { klass } }
      end

      def initialize(input)
        super "invalid value for #{klass}(): #{input.inspect}"
      end
    end
  end
end
