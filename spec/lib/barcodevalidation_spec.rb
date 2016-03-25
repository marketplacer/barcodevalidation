require "barcodevalidation"

RSpec.describe BarcodeValidation do
  it { is_expected.to be_an_instance_of Module }

  it "has a version number" do
    expect(BarcodeValidation::VERSION).not_to be nil
  end
end
