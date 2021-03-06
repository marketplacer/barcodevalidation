# frozen_string_literal: true

require "barcodevalidation"
require "benchmark"

RSpec.describe BarcodeValidation do
  it { is_expected.to be_an_instance_of Module }

  it "has a version number" do
    expect(BarcodeValidation::VERSION).not_to be nil
  end

  VALID_INPUTS = [
    937_179_004_167,
    "937179004167",
    9_312_631_133_233,
    "0753759137885",
    "0-753759-137885",
    "0 753759 137885",
  ].freeze

  INVALID_INPUTS = [
    144_793, # too short
    1_234_567_890_123, # invalid check digit
    50_140_424, # invalid check digit
    5_420_056_646_861,
    10_004_336,
    "48cm",
    123,
    1, # make sure only valid length barcodes are accepted
    22,
    333,
    4_444,
    55_555,
    666_666,
    777_777,
    99_999_999,
    12_345_678_901,
    123_456_789_012_345,
    "BODGYBARCODE",
    "",
    # make sure it doesn't choke on junk
    nil,
    true,
    false,
    -> { foobar },
    Class.new,
    Object.new,
    0...10,
    /abcd/,
  ].freeze

  describe ".scan" do
    subject(:scan) { described_class.scan input }
    let(:scan!) { described_class.scan! input }

    context "with a valid input" do
      VALID_INPUTS.each do |value|
        context "of '#{value}'" do
          let(:input) { value }
          it { is_expected.to be_valid }
          it "does not raise an error" do
            expect { scan! }.to_not raise_error
          end
        end
      end
    end

    context "with an invalid input" do
      INVALID_INPUTS.each do |value|
        context "of '#{value}'" do
          let(:input) { value }
          it { is_expected.to_not be_valid }
          it "raises an error" do
            expect { scan! }.to raise_error BarcodeValidation::Error
          end
        end
      end
    end

    describe "performance" do
      let!(:valid_inputs) { fixture_data("barcodes/valid.txt") }
      let!(:invalid_inputs) { fixture_data("barcodes/invalid.txt") }

      it "accepts all valid barcodes" do
        valid_inputs.each do |valid_input|
          result = described_class.scan(valid_input)
          expect(result).to be_valid
        end
      end

      it "rejects all invalid barcodes" do
        invalid_inputs.each do |invalid_input|
          result = described_class.scan(invalid_input)
          expect(result).to_not be_valid
        end
      end

      it "decides on a valid input quickly" do
        realtime = Benchmark.realtime do
          valid_inputs.each { |i| described_class.scan(i).valid? }
        end

        expect(realtime / valid_inputs.count).to be < 0.000_05 # 50us
      end
    end

    describe "conversion" do
      context "for an invalid barcode" do
        let(:input) { "123456" }

        context "#to_all_valid" do
          it "is an empty array" do
            expect(subject.to_all_valid).to eq([])
          end
        end

        context "#to_gtin_8" do
          it "is a BarcodeValidation::InvalidGTIN" do
            expect(subject.to_gtin_8.is_a?(BarcodeValidation::InvalidGTIN)).to be_truthy
          end
        end

        context "#to_gtin_12" do
          it "is a BarcodeValidation::InvalidGTIN" do
            expect(subject.to_gtin_12.is_a?(BarcodeValidation::InvalidGTIN)).to be_truthy
          end
        end

        context "#to_gtin_13" do
          it "is a BarcodeValidation::InvalidGTIN" do
            expect(subject.to_gtin_13.is_a?(BarcodeValidation::InvalidGTIN)).to be_truthy
          end
        end

        context "#to_gtin_14" do
          it "is a BarcodeValidation::InvalidGTIN" do
            expect(subject.to_gtin_14.is_a?(BarcodeValidation::InvalidGTIN)).to be_truthy
          end
        end
      end
    end
  end
end
