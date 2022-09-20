# frozen_string_literal: true

require "forwardable"
require_relative "invalid_gtin"

module BarcodeValidation
  module GTIN
    class << self
      def new(input)
        (class_for_input(input) || BarcodeValidation::InvalidGTIN).new(input)
      end

      # Classes that inherit from GTIN::Base auto-register themselves here.
      # Classes can prioritize themselves before others to implement subsets or other means of overlapping ranges.
      #
      # @api private Only for internal use.
      # @see GTIN::Base.prioritize_before For when you want to manipulte priorities.
      # @see GTIN::Base.abstract_class For when you want to make a GTIN class abstract (i.e. not included in this list)
      def prioritized_gtin_classes
        @prioritized_gtin_classes ||= []
      end

      # Ensure the provided class is removed from the list of prioritized GTIN classes.
      def remove_gtin_class(gtin_class)
        prioritized_gtin_classes.delete(gtin_class)
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
