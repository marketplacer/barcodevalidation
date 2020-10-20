require "barcodevalidation/mixin/has_check_digit"
require "barcodevalidation/mixin/value_object"
require "barcodevalidation/digit"
require "barcodevalidation/digit_sequence"
require "barcodevalidation/gtin"

RSpec.describe BarcodeValidation::GTIN::GTIN12 do
  subject(:gtin) { described_class.new(input) }

  context "#valid?" do
    context "whith a valid 8-digit code" do
      let(:input) { "12345670" }

      it 'is false' do
        expect(gtin).to_not be_valid
      end
    end

    context "with a valid 12-digit code" do
      let(:input) { "123456789012" }

      it 'is true' do
        expect(gtin).to be_valid
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
    before do
      expect(gtin.is_a?(described_class)).to be_truthy
      expect(gtin).to be_valid
    end

    context "to GTIN-8" do
      let(:gtin8) { gtin.to_gtin_8 }

      context "when prefixed with zeros" do
        let(:input) { "000012345670" }

        it 'is valid' do
          expect(gtin8).to be_valid
        end

        it 'is a BarcodeValidation::GTIN::GTIN8 instance' do
          expect(gtin8.is_a?(BarcodeValidation::GTIN::GTIN8)).to be_truthy
        end
      end

      context "when not prefixed with zeros" do
        let(:input) { "123456789012" }

        it 'is not valid' do
          expect(gtin8).to_not be_valid
        end

        it 'is a BarcodeValidation::InvalidGTIN instance' do
          expect(gtin8.is_a?(BarcodeValidation::InvalidGTIN)).to be_truthy
        end
      end
    end

    context "to GTIN-12" do
      let(:input) { "123456789012" }

      it 'returns itself' do
        expect(gtin.to_gtin_12).to eq(gtin)
      end
    end

    context "to GTIN-13" do
      let(:gtin13) { gtin.to_gtin_13 }

      before do
        expect(gtin13.is_a?(BarcodeValidation::GTIN::GTIN13)).to be_truthy
      end

      context "when prefixed with zeros" do
        let(:input) { "000012345670" }

        it 'returns a valid GTIN-13' do
          expect(gtin13).to be_valid
        end
      end

      context "when not prefixed with zeros" do
        let(:input) { "123456789012" }

        it 'returns a valid GTIN-13' do
          expect(gtin13).to be_valid
        end
      end
    end

    context "to GTIN-14" do
      let(:gtin14) { gtin.to_gtin_14 }

      before do
        expect(gtin14.is_a?(BarcodeValidation::GTIN::GTIN14)).to be_truthy
      end

      context "when prefixed with zeros" do
        let(:input) { "000012345670" }

        it 'is valid' do
          expect(gtin14).to be_valid
        end
      end

      context "when not prefixed with zeros" do
        let(:input) { "123456789012" }

        it 'returns a valid GTIN-14' do
          expect(gtin14).to be_valid
        end
      end
    end
  end
end
