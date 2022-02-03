# frozen_string_literal: true

module BarcodeValidation
  module Mixin
    module ValueObject
      def self.included(mod)
        mod.extend ClassMethods
      end

      module ClassMethods
      end

      def eql?(other)
        object_id == other.object_id
      end

      def inspect
        "#<#{description}>"
      end

      def pretty_print(value)
        value.text inspect
      end

      private

      def description
        "#{self.class}(#{self})"
      end
    end
  end
end
