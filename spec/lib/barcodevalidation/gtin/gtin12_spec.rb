# frozen_string_literal: true

require "barcodevalidation/mixin/has_check_digit"
require "barcodevalidation/mixin/value_object"
require "barcodevalidation/digit"
require "barcodevalidation/digit_sequence"
require "barcodevalidation/gtin"

RSpec.describe BarcodeValidation::GTIN::GTIN12 do
  subject(:gtin) { described_class.new(input) }

  describe "#valid?" do
    context "with a valid 8-digit code" do
      let(:input) { "12345670" }

      it "is false" do
        expect(gtin).not_to be_valid
      end
    end

    context "with a valid 12-digit code" do
      let(:input) { "123456789012" }

      it "is true" do
        expect(gtin).to be_valid
      end
    end

    context "with a valid 13-digit code" do
      let(:input) { "1234567890128" }

      it "is false" do
        expect(gtin).not_to be_valid
      end
    end

    context "with a valid 14-digit code" do
      let(:input) { "12345678901231" }

      it "is false" do
        expect(gtin).not_to be_valid
      end
    end

    context "with an all zero 12-digit code" do
      let(:input) { "000000000000" }

      it "is false" do
        expect(gtin).not_to be_valid
      end
    end
  end

  context "conversion" do
    before do
      expect(gtin).to be_a(described_class)
    end

    context "to_all_valid" do
      context "with an all zero GTIN-8 code" do
        let(:input) { "00000000" }

        it "does not include the GTIN-8 instance" do
          expect(gtin.to_all_valid).to be_empty
        end
      end

      context "with an all zero GTIN-12 code" do
        let(:input) { "000000000000" }

        it "does not include the GTIN-12 instance" do
          expect(gtin.to_all_valid).to be_empty
        end
      end

      context "with an all zero GTIN-13 code" do
        let(:input) { "0000000000000" }

        it "does not include the GTIN-13 instance" do
          expect(gtin.to_all_valid).to be_empty
        end
      end

      context "with an all zero GTIN-14 code" do
        let(:input) { "00000000000000" }

        it "does not include the GTIN-14 instance" do
          expect(gtin.to_all_valid).to be_empty
        end
      end
    end

    context "with valid gtin" do
      before do
        expect(gtin).to be_valid
      end

      context "to GTIN-8" do
        let(:gtin8) { gtin.to_gtin_8 }

        context "when prefixed with zeros" do
          let(:input) { "000012345670" }

          it "is valid" do
            expect(gtin8).to be_valid
          end

          it "is a BarcodeValidation::GTIN::GTIN8 instance" do
            expect(gtin8).to be_a(BarcodeValidation::GTIN::GTIN8)
          end
        end

        context "when not prefixed with zeros" do
          let(:input) { "123456789012" }

          it "is not valid" do
            expect(gtin8).not_to be_valid
          end

          it "is a BarcodeValidation::InvalidGTIN instance" do
            expect(gtin8).to be_a(BarcodeValidation::InvalidGTIN)
          end
        end
      end

      context "to GTIN-12" do
        let(:input) { "123456789012" }

        it "returns itself" do
          expect(gtin.to_gtin_12).to eq(gtin)
        end
      end

      context "to GTIN-13" do
        let(:gtin13) { gtin.to_gtin_13 }

        before do
          expect(gtin13).to be_a(BarcodeValidation::GTIN::GTIN13)
        end

        context "when prefixed with zeros" do
          let(:input) { "000012345670" }

          it "returns a valid GTIN-13" do
            expect(gtin13).to be_valid
          end
        end

        context "when not prefixed with zeros" do
          let(:input) { "123456789012" }

          it "returns a valid GTIN-13" do
            expect(gtin13).to be_valid
          end
        end
      end

      context "to GTIN-14" do
        let(:gtin14) { gtin.to_gtin_14 }

        before do
          expect(gtin14).to be_a(BarcodeValidation::GTIN::GTIN14)
        end

        context "when prefixed with zeros" do
          let(:input) { "000012345670" }

          it "is valid" do
            expect(gtin14).to be_valid
          end
        end

        context "when not prefixed with zeros" do
          let(:input) { "123456789012" }

          it "returns a valid GTIN-14" do
            expect(gtin14).to be_valid
          end
        end
      end

      context "to_all_valid" do
        context "with a zero-padded GTIN-8 code" do
          let(:input) { "000012345670" }

          it "includes a GTIN-8 instance" do
            expect(gtin.to_all_valid).to be_any { |code| code.is_a?(BarcodeValidation::GTIN::GTIN8) }
          end
        end

        context "when a GTIN-12 code without zero padding" do
          let(:input) { "123456789012" }

          it "does not includes a GTIN-8 instance" do
            expect(gtin.to_all_valid).to be_none { |code| code.is_a?(BarcodeValidation::GTIN::GTIN8) }
          end

          it "includes a GTIN-12 instance" do
            expect(gtin.to_all_valid).to be_any { |code| code.is_a?(described_class) }
          end

          it "includes a zero-padded GTIN-13 instance" do
            expect(gtin.to_all_valid).to be_any { |code| code.is_a?(BarcodeValidation::GTIN::GTIN13) }
          end

          it "includes a zero-padded GTIN-14 instance" do
            expect(gtin.to_all_valid).to be_any { |code| code.is_a?(BarcodeValidation::GTIN::GTIN14) }
          end
        end
      end
    end
  end
end
