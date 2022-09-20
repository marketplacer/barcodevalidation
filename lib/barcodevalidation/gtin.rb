# frozen_string_literal: true

require "forwardable"
require_relative "invalid_gtin"

module BarcodeValidation
  # GTIN is responsible for wrapping input in an appropriate GTIN::Base sub-class.
  # An important part of this involves managing the prioritized list of GTIN classes we use for handling input.
  # The methods implemented here are used by GTIN::Base to manage this list and prioritize classes.
  module GTIN
    class << self
      def new(input)
        (class_for_input(input) || BarcodeValidation::InvalidGTIN).new(input)
      end

      # Classes that inherit from GTIN::Base auto-register themselves here.
      # Classes can prioritize themselves before others to implement subsets or other means of overlapping ranges.
      #
      # @api private Only for internal use.
      # @see GTIN::Base.prioritize_before For when you want to manipulate priorities.
      # @see GTIN::Base.abstract_class For when you want to make a GTIN class abstract (i.e. not included in this list)
      def prioritized_gtin_classes
        @prioritized_gtin_classes ||= []
      end

      # Adds the provided class to the back of the list of prioritized GTIN classes.
      def append_gtin_class(gtin_class)
        return if gtin_class?(gtin_class)

        prioritized_gtin_classes.push(gtin_class)
        nil
      end

      # Ensure the provided class is removed from the list of prioritized GTIN classes.
      def remove_gtin_class(gtin_class)
        prioritized_gtin_classes.delete(gtin_class)
        nil
      end

      # Is this a registered prioritized GTIN class?
      # @return [true, false]
      def gtin_class?(gtin_class)
        prioritized_gtin_classes.include?(gtin_class)
      end

      # @param [Class] high_priority_class The higher priority GTIN class you want to move before the low priority class
      # @param [Class] low_priority_class The low priority GTIN class that the high priority one is moved before
      def reprioritize_before(high_priority_class, low_priority_class)
        low_priority_index = prioritized_gtin_classes.index(low_priority_class)
        remove_gtin_class(high_priority_class)
        prioritized_gtin_classes.insert(low_priority_index, high_priority_class)
        nil
      end

      private

      def class_for_input(input)
        input = input.to_s.freeze
        prioritized_gtin_classes.find { |klass| klass.handles?(input) }
      end
    end
  end
end

# Load GTIN implementations after we have our registration setup
require_relative "gtin/base"
require_relative "gtin/check_digit"
require_relative "gtin/gtin8"
require_relative "gtin/gtin12"
require_relative "gtin/gtin13"
require_relative "gtin/gtin14"
