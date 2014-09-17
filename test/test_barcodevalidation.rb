require 'minitest_helper'

class TestBarcodevalidation < MiniTest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Barcodevalidation::VERSION
  end

  def test_valid_barcodes
    [
      937179004167,
      9312631133233
    ].each { |barcode| assert Barcodevalidation.valid?(barcode), barcode }
  end

  def test_invalid_barcodes
    [
      144793, #too short
      1234567890123, #invalid check digit
      50140424, #invalid check digit
      5420056646861,
      10004336
    ].each { |barcode| refute Barcodevalidation.valid?(barcode), barcode }
  end
end
