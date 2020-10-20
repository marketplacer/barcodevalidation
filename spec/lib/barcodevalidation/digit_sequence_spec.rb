# frozen_string_literal: true

require "barcodevalidation/mixin/value_object"
require "barcodevalidation/error/argument_error_class"
require "barcodevalidation/digit"
require "barcodevalidation/digit_sequence"

# rubocop:disable Metrics/BlockLength
RSpec.describe BarcodeValidation::DigitSequence do
  subject(:sequence) { described_class.new(input) }
  let(:input) { 123_456 }

  describe "#==" do
    it "considers equivalent sequences equal" do
      first = described_class.new(123_456)
      second = described_class.new("123456")
      third = described_class.new([1, 2, 3, 4, 5, 6])
      expect(first).to eq second
      expect(second).to eq third
      expect(first).to eq third
    end
  end

  context "in comparison to another sequence" do
    let(:other) { described_class.new(other_input) }

    context "with an equivalent sequence" do
      let(:other_input) { input }
      it { is_expected.to eq other }
      it { is_expected.to eql other }
      its(:hash) { is_expected.to eq other.hash }
      its(:object_id) { is_expected.to eq other.object_id }
    end

    context "with a different sequence" do
      let(:other_input) { 987_654 }
      it { is_expected.to_not eq other }
      it { is_expected.to_not eql other }
      its(:hash) { is_expected.to_not eq other.hash }
      its(:object_id) { is_expected.to_not eq other.object_id }
    end

    context "when the other is unrelated" do
      let(:other) { false }
      it { is_expected.to_not eq other }
      it { is_expected.to_not eql other }
      its(:hash) { is_expected.to_not eq other.hash }
      its(:object_id) { is_expected.to_not eq other.object_id }
    end
  end

  describe "#==" do
    let(:other) { described_class.new(other_input) }
    subject(:result) { sequence == other }

    context "when the other is equivalent" do
      let(:other_input) { input }
      it { is_expected.to be true }
    end

    context "when the other is different" do
      let(:other_input) { 234_567 }
      it { is_expected.to be false }
    end

    context "when the other is unrelated" do
      let(:other) { false }
      it { is_expected.to be false }
    end
  end

  describe "#*" do
    subject(:result) { sequence * times }
    let(:times) { 3 }
    it { is_expected.to be_an_instance_of described_class }
  end

  {
    "String of digits" => "2345",
    "Fixnum" => 2_345,
  }.each do |type, value|
    context "with a #{type} of '#{value}'" do
      let(:input) { value }
      its(:to_s) { is_expected.to eq "2345" }
      its(:inspect) { is_expected.to eq "#<#{described_class}(2345)>" }
      its(:length) { is_expected.to eq 4 }
      its(:first) { is_expected.to eq 2 }
      its(:last) { is_expected.to eq 5 }
    end
  end

  {
    "String including a leading zero" => "0123",
    "array of Fixnums" => [0, 1, 2, 3],
    "array of String digits" => %w[0 1 2 3],
  }.each do |type, value|
    context "with the #{type} of '#{value}'" do
      let(:input) { value }
      its(:to_s) { is_expected.to eq "0123" }
      its(:inspect) { is_expected.to eq "#<#{described_class}(0123)>" }
      its(:length) { is_expected.to eq 4 }
      its(:first) { is_expected.to eq 0 }
      its(:last) { is_expected.to eq 3 }
    end
  end

  context "with an invalid input" do
    let(:input) { nil }
    it "fails" do
      expect { sequence }.to raise_error(
        BarcodeValidation::DigitSequence::ArgumentError,
        "invalid value for BarcodeValidation::DigitSequence(): nil",
      )
    end
  end
end
# rubocop:enable Metrics/BlockLength
