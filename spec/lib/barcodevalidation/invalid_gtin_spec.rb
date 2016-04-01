require "barcodevalidation/invalid_gtin"

RSpec.describe BarcodeValidation::InvalidGTIN do
  subject(:gtin) { described_class.new(input, error: error) }
  let(:input) { double("input", inspect: "INPUT", reverse: "TUPNI") }
  let(:error) { double("error", message: "ERROR") }

  it { is_expected.to_not be_valid }

  describe "#inspect" do
    subject(:inspect) { gtin.inspect }
    it { is_expected.to start_with "#<#{described_class} " }
    it { is_expected.to end_with %(input=INPUT error="ERROR">) }
  end

  describe "delegated methods" do
    subject(:reversed) { gtin.reverse }
    it { is_expected.to_not be_a described_class }
    it { is_expected.to eq "TUPNI" }
  end
end
