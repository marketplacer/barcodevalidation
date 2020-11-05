# frozen_string_literal: true

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

  describe "#to_all_valid" do
    it "is an empty array" do
      expect(subject.to_all_valid).to eq([])
    end
  end

  describe "#to_gtin_8" do
    it "returns itself" do
      expect(subject.to_gtin_8).to eq(subject)
    end

    it "is not valid" do
      expect(subject.to_gtin_8).to_not be_valid
    end
  end

  describe "#to_gtin_12" do
    it "returns itself" do
      expect(subject.to_gtin_12).to eq(subject)
    end

    it "is not valid" do
      expect(subject.to_gtin_8).to_not be_valid
    end
  end

  describe "#to_gtin_13" do
    it "returns itself" do
      expect(subject.to_gtin_13).to eq(subject)
    end

    it "is not valid" do
      expect(subject.to_gtin_8).to_not be_valid
    end
  end

  describe "#to_gtin_14" do
    it "returns itself" do
      expect(subject.to_gtin_14).to eq(subject)
    end

    it "is not valid" do
      expect(subject.to_gtin_8).to_not be_valid
    end
  end
end
