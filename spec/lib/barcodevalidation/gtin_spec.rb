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
    it { is_expected.to_not be_valid }

    it "exposes the CheckDigit" do
      expect(gtin.check_digit).to_not be_valid
    end
  end

  context "with a sequence of digits of unknown length" do
    let(:input) { 123_456_789_012_345_678 }
    it { is_expected.to_not be_valid }
  end

  context "with a non-numeric input" do
    let(:input) { "abcdef" }
    it { is_expected.to_not be_valid }
  end

  describe "sequence methods" do
    let(:input) { 12_345_678 }
    subject(:sequence) { gtin.reverse }
    it { is_expected.to_not be_a described_class }
  end

  describe "factory interface" do
    context "for 8-digit input" do
      let(:input) { "12345678" }

      it "constructs a BarcodeValidation::GTIN::GTIN8" do
        expect(gtin.is_a?(BarcodeValidation::GTIN::GTIN8)).to be_truthy
      end
    end

    context "for 12-digit input" do
      let(:input) { "123456789012" }

      it "constructs a BarcodeValidation::GTIN::GTIN12" do
        expect(gtin.is_a?(BarcodeValidation::GTIN::GTIN12)).to be_truthy
      end
    end

    context "for 13-digit input" do
      let(:input) { "1234567890123" }

      it "constructs a BarcodeValidation::GTIN::GTIN13" do
        expect(gtin.is_a?(BarcodeValidation::GTIN::GTIN13)).to be_truthy
      end
    end

    context "for 14-digit input" do
      let(:input) { "12345678901234" }

      it "constructs a BarcodeValidation::GTIN::GTIN14" do
        expect(gtin.is_a?(BarcodeValidation::GTIN::GTIN14)).to be_truthy
      end
    end

    context "for non-standard input length" do
      let(:input) { "1234" }

      it "constructs a BarcodeValidation::InvalidGTIN" do
        expect(gtin.is_a?(BarcodeValidation::InvalidGTIN)).to be_truthy
      end
    end
  end

  describe "conversion" do
    context "when converting from a superset down to a subset" do
      let(:gtin8) { gtin.to_gtin_8 }

      context "for a zero-padded code" do
        let(:input) { "000012345670" }

        it "returns an instance of the concrete class for that subset" do
          expect(gtin8.is_a?(BarcodeValidation::GTIN::GTIN8)).to be_truthy
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
    after(:each) do
      # Remove references to classes we may have generated during a test to ensure we don't pollute the list of classes for other tests
      classes_to_cleanup.each do |class_sym|
        next unless Object.const_defined?(class_sym)

        class_obj = Object.const_get(class_sym)
        BarcodeValidation::GTIN.remove_gtin_class(class_obj)
        Object.__send__(:remove_const, class_sym)
      end
    end

    describe "inheritance" do
      let(:classes_to_cleanup) { [:MyCustomGTIN] }

      it "appends itself to BarcodeValidation::GTIN.prioritized_gtin_classes when inheriting from GTIN::Base" do
        class MyCustomGTIN < BarcodeValidation::GTIN::Base
        end

        expect(BarcodeValidation::GTIN.gtin_class?(MyCustomGTIN)).to eq(true)
      end

      it "appends itself to BarcodeValidation::GTIN.prioritized_gtin_classes when inheriting from a GTIN::Base descendant" do
        class MyCustomGTIN < BarcodeValidation::GTIN::GTIN12
        end

        expect(BarcodeValidation::GTIN.gtin_class?(MyCustomGTIN)).to eq(true)
      end
    end

    describe "prioritize_before" do
      let(:classes_to_cleanup) { [:MyCustomGTIN13] }

      it "causes this class to be evaluated before the other one when checking which one handles a GTIN input" do
        class MyCustomGTIN13 < BarcodeValidation::GTIN::GTIN13
          prioritize_before BarcodeValidation::GTIN::GTIN13

          def self.handles?(input)
            input.start_with?("123") && super
          end
        end

        expect(BarcodeValidation::GTIN.new("1234567890123").class).to eq(MyCustomGTIN13)
        expect(BarcodeValidation::GTIN.new("1004567890123").class).to eq(BarcodeValidation::GTIN::GTIN13)
      end
    end

    describe "abstract_class" do
      let(:classes_to_cleanup) { %i[MyCustomAbstractGTIN MyCustomParentGTIN MyCustomChildGTIN] }

      it "removes itself from BarcodeValidation::GTIN.prioritized_gtin_classes" do
        class MyCustomAbstractGTIN < BarcodeValidation::GTIN::Base
          abstract_class
        end

        expect(BarcodeValidation::GTIN.gtin_class?(MyCustomAbstractGTIN)).to eq(false)
      end

      it "is not inherited by children" do
        class MyCustomParentGTIN < BarcodeValidation::GTIN::Base
          abstract_class
        end

        class MyCustomChildGTIN < MyCustomParentGTIN
        end

        expect(BarcodeValidation::GTIN.gtin_class?(MyCustomChildGTIN)).to eq(true)
      end
    end
  end
end
