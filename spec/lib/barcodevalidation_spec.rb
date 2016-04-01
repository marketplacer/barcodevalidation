require "barcodevalidation"

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
  end
end
