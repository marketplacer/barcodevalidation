# frozen_string_literal: true

require "barcodevalidation/mixin/has_check_digit"
require "barcodevalidation/mixin/value_object"
require "barcodevalidation/digit"
require "barcodevalidation/digit_sequence"
require "barcodevalidation/gtin"

RSpec.describe BarcodeValidation::GTIN do
  subject(:gtin) { described_class.new(input) }

  context "with a valid UPC" do
    let(:input) { 123_456_789_012 }

    it { is_expected.to be_valid }
  end

  context "with a valid UPC where the check digit is 0" do
    let(:input) { 123_456_789_050 }

    it { is_expected.to be_valid }
  end

  context "with a UPC with an invalid check digit" do
    let(:input) { 123_456_789_011 }

    it { is_expected.not_to be_valid }

    it "exposes the CheckDigit" do
      expect(gtin.check_digit).not_to be_valid
    end
  end

  context "with a sequence of digits of unknown length" do
    let(:input) { 123_456_789_012_345_678 }

    it { is_expected.not_to be_valid }
  end

  context "with a non-numeric input" do
    let(:input) { "abcdef" }

    it { is_expected.not_to be_valid }
  end

  describe "sequence methods" do
    subject(:sequence) { gtin.reverse }

    let(:input) { 12_345_678 }

    it { is_expected.not_to be_a described_class }
  end

  describe "factory interface" do
    context "for 8-digit input" do
      let(:input) { "12345678" }

      it "constructs a BarcodeValidation::GTIN::GTIN8" do
        expect(gtin).to be_a(BarcodeValidation::GTIN::GTIN8)
      end
    end

    context "for 12-digit input" do
      let(:input) { "123456789012" }

      it "constructs a BarcodeValidation::GTIN::GTIN12" do
        expect(gtin).to be_a(BarcodeValidation::GTIN::GTIN12)
      end
    end

    context "for 13-digit input" do
      let(:input) { "1234567890123" }

      it "constructs a BarcodeValidation::GTIN::GTIN13" do
        expect(gtin).to be_a(BarcodeValidation::GTIN::GTIN13)
      end
    end

    context "for 14-digit input" do
      let(:input) { "12345678901234" }

      it "constructs a BarcodeValidation::GTIN::GTIN14" do
        expect(gtin).to be_a(BarcodeValidation::GTIN::GTIN14)
      end
    end

    context "for non-standard input length" do
      let(:input) { "1234" }

      it "constructs a BarcodeValidation::InvalidGTIN" do
        expect(gtin).to be_a(BarcodeValidation::InvalidGTIN)
      end
    end
  end

  describe "conversion" do
    context "when converting from a superset down to a subset" do
      let(:gtin8) { gtin.to_gtin_8 }

      context "for a zero-padded code" do
        let(:input) { "000012345670" }

        it "returns an instance of the concrete class for that subset" do
          expect(gtin8).to be_a(BarcodeValidation::GTIN::GTIN8)
        end
      end

      context "for a code that is not zero-padded" do
        let(:input) { "123456789012" }
        let(:error_message) do
          "invalid value for BarcodeValidation::GTIN::GTIN8(): #{input.inspect}"
        end
        let(:is_an_invalid_gtin) { gtin8.is_a?(BarcodeValidation::InvalidGTIN) }

        it "returns a BarcodeValidation::InvalidGTIN instance" do
          expect(is_an_invalid_gtin).to be_truthy
        end

        it "has a meaningful error message" do
          expect(gtin8.error_message).to eq(error_message)
        end
      end
    end
  end

  describe "custom classes" do
    describe "inheritance" do
      context "MyCustomGTIN" do
        before do
          klass = Class.new(BarcodeValidation::GTIN::Base) do
          end

          stub_const("MyCustomGTIN", klass)
        end

        it "appends itself to BarcodeValidation::GTIN.prioritized_gtin_classes when inheriting from GTIN::Base" do
          expect(described_class.gtin_class?(MyCustomGTIN)).to be(true)
        end
      end

      context "MyCustomGTIN12" do
        before do
          klass = Class.new(BarcodeValidation::GTIN::GTIN12) do
          end
          stub_const("MyCustomGTIN", klass)
        end

        it "appends itself to BarcodeValidation::GTIN.prioritized_gtin_classes when inheriting from a GTIN::Base descendant" do
          expect(described_class.gtin_class?(MyCustomGTIN)).to be(true)
        end
      end
    end

    describe "prioritize_before" do
      before do
        klass = Class.new(BarcodeValidation::GTIN::GTIN13) do
          prioritize_before BarcodeValidation::GTIN::GTIN13

          def self.handles?(input)
            input.start_with?("123") && super
          end
        end

        stub_const("MyCustomGTIN13", klass)
      end

      it "causes this class to be evaluated before the other one when checking which one handles a GTIN input" do
        expect(described_class.new("1234567890123").class).to eq(MyCustomGTIN13)
        expect(described_class.new("1004567890123").class).to eq(BarcodeValidation::GTIN::GTIN13)
      end
    end

    describe "abstract_class" do
      before do
        klass = Class.new(BarcodeValidation::GTIN::Base) do
          abstract_class
        end
        stub_const("MyCustomAbstractGTIN", klass)
      end

      it "removes itself from BarcodeValidation::GTIN.prioritized_gtin_classes" do
        expect(described_class.gtin_class?(MyCustomAbstractGTIN)).to be(false)
      end

      context "child class" do
        before do
          klass = Class.new(MyCustomAbstractGTIN) do
          end
          stub_const("MyCustomChildGTIN", klass)
        end

        it "is not inherited by children" do
          expect(described_class.gtin_class?(MyCustomChildGTIN)).to be(true)
        end
      end
    end
  end
end
