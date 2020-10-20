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
  end
end
