require "barcodevalidation/mixin/has_check_digit"
require "barcodevalidation/mixin/value_object"
require "barcodevalidation/digit"
require "barcodevalidation/digit_sequence"
require "barcodevalidation/gtin"

RSpec.describe BarcodeValidation::GTIN::GTIN8 do
  subject(:gtin) { described_class.new(input) }

  context "#valid?" do
    context "whith a valid 8-digit code" do
      let(:input) { "12345670" }

      it 'is true' do
        expect(gtin).to be_valid
      end
    end

    context "with a valid 12-digit code" do
      let(:input) { "123456789012" }

      it 'is false' do
        expect(gtin).to_not be_valid
      end
    end

    context "with a valid 13-digit code" do
      let(:input) { "1234567890128" }

      it 'is false' do
        expect(gtin).to_not be_valid
      end
    end

    context "with a valid 14-digit code" do
      let(:input) { "12345678901231" }

      it 'is false' do
        expect(gtin).to_not be_valid
      end
    end
  end

  context "converstion" do
    let(:input) { "12345670" }

    before do
      expect(gtin.is_a?(described_class)).to be_truthy
      expect(gtin).to be_valid
    end

    context "to GTIN-8" do
      it 'returns itself' do
        expect(gtin.to_gtin_8).to eq(gtin)
      end
    end

    context "to GTIN-12" do
      let(:gtin12) { gtin.to_gtin_12 }

      before do
        expect(gtin12.is_a?(BarcodeValidation::GTIN::GTIN12)).to be_truthy
      end

      it 'returns a valid GTIN-12' do
        expect(gtin12).to be_valid
      end
    end

    context "to GTIN-13" do
      let(:gtin13) { gtin.to_gtin_13 }

      before do
        expect(gtin13.is_a?(BarcodeValidation::GTIN::GTIN13)).to be_truthy
      end

      it 'returns a valid GTIN-13' do
        expect(gtin13).to be_valid
      end
    end

    context "to GTIN-14" do
      let(:gtin14) { gtin.to_gtin_14 }

      before do
        expect(gtin14.is_a?(BarcodeValidation::GTIN::GTIN14)).to be_truthy
      end

      it 'returns a valid GTIN-14' do
        expect(gtin14).to be_valid
      end
    end
  end
end
