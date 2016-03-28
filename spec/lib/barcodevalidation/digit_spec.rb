require "barcodevalidation/mixin/value_object"
require "barcodevalidation/digit"

RSpec.describe BarcodeValidation::Digit do
  subject(:digit) { described_class.new(input) }
  let(:input) { 9 }

  context "in comparison to another digit" do
    let(:other_digit) { described_class.new(other_input) }

    context "with an equivalent digit" do
      let(:other_input) { input }
      it { is_expected.to eq other_digit }
      it { is_expected.to eql other_digit }
      its(:hash) { is_expected.to eq other_digit.hash }
      its(:object_id) { is_expected.to eq other_digit.object_id }
      its(:inspect) { is_expected.to eq other_digit.inspect }
    end

    context "with a different digit" do
      let(:other_input) { 8 }
      it { is_expected.to_not eq other_digit }
      it { is_expected.to_not eql other_digit }
      its(:hash) { is_expected.to_not eq other_digit.hash }
      its(:object_id) { is_expected.to_not eq other_digit.object_id }
      its(:inspect) { is_expected.to_not eq other_digit.inspect }
    end
  end

  context "with a valid value" do
    let(:input) { 3 }
    it { is_expected.to be_an_instance_of described_class }
    it { is_expected.to be_frozen }
    it { is_expected.to eq 3 }
    it { is_expected.to_not eq 2 }
    its(:to_s) { is_expected.to eq "3" }
    its(:inspect) { is_expected.to eq "#<BarcodeValidation::Digit(3)>" }
  end

  context "with a floating-point value" do
    let(:input) { 8.5 }
    it { is_expected.to be_an_instance_of described_class }
    it { is_expected.to be_frozen }
    it { is_expected.to eq 8 }
    it { is_expected.to_not eq 9 }
    its(:to_s) { is_expected.to eq "8" }
    its(:inspect) { is_expected.to eq "#<BarcodeValidation::Digit(8)>" }
  end

  context "with a nil value" do
    let(:input) { nil }
    it "fails with an error message" do
      expect { digit }.to raise_error TypeError,
                                      "can't convert nil into Integer"
    end
  end

  context "with an out-of-range value" do
    let(:input) { 10 }
    it "fails with an error message" do
      expect { digit }.to raise_error \
        BarcodeValidation::Digit::ArgumentError,
        "invalid value for BarcodeValidation::Digit(): 10"
    end
  end
end
