# frozen_string_literal: true

require "barcodevalidation/mixin/has_check_digit"
require "barcodevalidation/mixin/value_object"
require "barcodevalidation/digit"
require "barcodevalidation/digit_sequence"
require "barcodevalidation/gtin"

RSpec.describe BarcodeValidation::GTIN do
  subject(:gtin) { described_class.new(input) }

  context "with a valid UPC" do
    let(:input) { 123_456_789_012 }
    it { is_expected.to be_valid }
  end

  context "with a valid UPC where the check digit is 0" do
    let(:input) { 123_456_789_050 }
    it { is_expected.to be_valid }
  end

  context "with a UPC with an invalid check digit" do
    let(:input) { 123_456_789_011 }
    it { is_expected.to_not be_valid }
  end

  context "with a sequence of digits of unknown length" do
    let(:input) { 123_456_789_012_345_678 }
    it { is_expected.to_not be_valid }
  end

  context "with a non-numeric input" do
    let(:input) { "abcdef" }
    it { is_expected.to_not be_valid }
  end

  describe "sequence methods" do
    let(:input) { 123 }
    subject(:sequence) { gtin.reverse }
    it { is_expected.to_not be_a described_class }
  end
end
