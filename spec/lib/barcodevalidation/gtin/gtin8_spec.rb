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
end
