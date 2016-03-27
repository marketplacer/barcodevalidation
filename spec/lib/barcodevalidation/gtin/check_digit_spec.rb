require "barcodevalidation/mixin/has_check_digit"
require "barcodevalidation/mixin/value_object"
require "barcodevalidation/digit"
require "barcodevalidation/digit_sequence"
require "barcodevalidation/gtin"

RSpec.describe BarcodeValidation::GTIN::CheckDigit do
  context "when initialized with a single digit" do
    subject(:digit) { described_class.new(input) }
    let(:input) { 1 }

    it { is_expected.to eq 1 }
    it { is_expected.to be_frozen }
    it { is_expected.to be_valid }
    its(:to_s) { is_expected.to eq "1" }
    its(:actual) { is_expected.to eq 1 }
    its(:expected) { is_expected.to eq 1 }
    its(:dup) { is_expected.to be subject }
    its(:inspect) { is_expected.to eq "#<#{described_class}(1)>" }
    its("actual.inspect") { is_expected.to eq digit.expected.inspect }
  end

  context "when initialized with an actual and expected digit" do
    subject(:digit) { described_class.new(actual, expected: expected) }
    let(:actual) { 2 }
    let(:expected) { 1 }

    it { is_expected.to eq 2 }
    it { is_expected.to be_frozen }
    it { is_expected.to_not be_valid }
    its(:to_s) { is_expected.to eq "2" }
    its(:actual) { is_expected.to eq 2 }
    its(:expected) { is_expected.to eq 1 }
    its(:dup) { is_expected.to be subject }

    describe "#inspect" do
      subject(:result) { digit.inspect }
      it { is_expected.to start_with "#<#{described_class}(2)" }
      it { is_expected.to end_with "invalid: expected 1>" }
    end
  end
end
