# frozen_string_literal: true

require "delegate"

module BarcodeValidation
  class InvalidGTIN < SimpleDelegator
    def initialize(input, error: nil)
      @error = error
      super(input)
    end

    def valid?
      false
    end

    def inspect
      %(#<#{self.class} input=#{super} error="#{error_message}">)
    end

    def error_message
      return @error.message if @error.respond_to? :message

      @error.inspect
    end

    def to_all_valid
      []
    end

    def to_gtin_8
      self
    end

    def to_gtin_12
      self
    end

    def to_gtin_13
      self
    end

    def to_gtin_14
      self
    end
  end
end
