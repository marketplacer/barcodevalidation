require "barcodevalidation/mixin/has_check_digit"
require "barcodevalidation/mixin/value_object"
require "barcodevalidation/digit"
require "barcodevalidation/digit_sequence"
require "barcodevalidation/barcode"

RSpec.describe BarcodeValidation::Barcode do
  subject(:barcode) { described_class.new(input) }

  context "with a valid UPC" do
    let(:input) { 123_456_789_012 }
    it { is_expected.to be_valid }
  end

  context "with a UPC with an invalid check digit" do
    let(:input) { 123_456_789_011 }
    it { is_expected.to_not be_valid }
  end
end
