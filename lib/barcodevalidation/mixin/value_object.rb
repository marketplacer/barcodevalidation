require "adamantium"

module BarcodeValidation
  module Mixin
    module ValueObject
      def self.included(mod)
        mod.extend ClassMethods
        mod.include Adamantium
      end

      module ClassMethods
        # Memoizes return values based on the inputs
        def new(*args)
          (@__new_cache ||= {})[memoization_key(*args)] ||= super
        end

        # Customise the memoisation logic in classes which include this
        def memoization_key(*args)
          args
        end
      end

      def eql?(other)
        object_id == other.object_id
      end

      def inspect
        "#<#{description}>"
      end

      def pretty_print(pp)
        pp.text inspect
      end

      private

      def description
        "#{self.class}(#{self})"
      end
    end
  end
end
