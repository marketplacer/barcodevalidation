require "barcodevalidation/mixin/has_check_digit"
require "barcodevalidation/mixin/value_object"
require "barcodevalidation/digit"
require "barcodevalidation/digit_sequence"
require "barcodevalidation/gtin"

RSpec.describe BarcodeValidation::GTIN::GTIN13 do
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

      it 'is false' do
        expect(gtin).to_not be_valid
      end
    end

    context "with a valid 13-digit code" do
      let(:input) { "1234567890128" }

      it 'is true' do
        expect(gtin).to be_valid
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

      before do
      end

      context "when prefixed with zeros" do
        let(:input) { "0000012345670" }

        it 'is valid' do
          expect(gtin8).to be_valid
        end

        it 'is a BarcodeValidation::GTIN::GTIN8' do
          expect(gtin8.is_a?(BarcodeValidation::GTIN::GTIN8)).to be_truthy
        end
      end

      context "when not prefixed with zeros" do
        let(:input) { "1234567890128" }

        it 'is not valid' do
          expect(gtin8).to_not be_valid
        end

        it 'is a BarcodeValidation::InvalidGTIN' do
          expect(gtin8.is_a?(BarcodeValidation::InvalidGTIN)).to be_truthy
        end
      end
    end

    context "to GTIN-12" do
      let(:gtin12) { gtin.to_gtin_12 }

      context "when prefixed with zeros" do
        let(:input) { "0123456789012" }

        it 'is valid' do
          expect(gtin12).to be_valid
        end

        it 'is a BarcodeValidation::GTIN::GTIN12' do
          expect(gtin12.is_a?(BarcodeValidation::GTIN::GTIN12)).to be_truthy
        end
      end

      context "when not prefixed with zeros" do
        let(:input) { "1234567890128" }

        it 'is not valid' do
          expect(gtin12).to_not be_valid
        end

        it 'is a BarcodeValidation::InvalidGTIN' do
          expect(gtin12.is_a?(BarcodeValidation::InvalidGTIN)).to be_truthy
        end
      end
    end

    context "to GTIN-13" do
      let(:input) { "1234567890128" }

      it 'returns itself' do
        expect(gtin.to_gtin_13).to eq(gtin)
      end
    end

    context "to GTIN-14" do
      let(:gtin14) { gtin.to_gtin_14 }

      before do
        expect(gtin14.is_a?(BarcodeValidation::GTIN::GTIN14)).to be_truthy
      end

      context "when prefixed with zeros" do
        let(:input) { "0123456789012" }

        it 'returns a valid GTIN-14' do
          expect(gtin14).to be_valid
        end
      end

      context "when not prefixed with zeros" do
        let(:input) { "1234567890128" }

        it 'returns a valid GTIN-14' do
          expect(gtin14).to be_valid
        end
      end
    end

    context "to_all_valid" do
      context "with a zero-padded GTIN-8 code" do
        let(:input) { "0000012345670" }

        it 'includes a GTIN-8 instance' do
          expect(gtin.to_all_valid.any? {|code| code.is_a?(BarcodeValidation::GTIN::GTIN8)}).to be_truthy
        end
      end

      context "with a zero-padded GTIN-12 code" do
        let(:input) { "0123456789012" }

        it 'includes a GTIN-12 instance' do
          expect(gtin.to_all_valid.any? {|code| code.is_a?(BarcodeValidation::GTIN::GTIN12)}).to be_truthy
        end
      end

      context "when a GTIN-13 code without zero padding" do
        let(:input) { "1234567890128" }

        it 'does not includes a GTIN-8 instance' do
          expect(gtin.to_all_valid.none? {|code| code.is_a?(BarcodeValidation::GTIN::GTIN8)}).to be_truthy
        end

        it 'does not includes a GTIN-12 instance' do
          expect(gtin.to_all_valid.none? {|code| code.is_a?(BarcodeValidation::GTIN::GTIN12)}).to be_truthy
        end

        it 'includes a GTIN-13 instance' do
          expect(gtin.to_all_valid.any? {|code| code.is_a?(BarcodeValidation::GTIN::GTIN13)}).to be_truthy
        end

        it 'includes a zero-padded GTIN-14 instance' do
          expect(gtin.to_all_valid.any? {|code| code.is_a?(BarcodeValidation::GTIN::GTIN14)}).to be_truthy
        end
      end
    end
  end
end
