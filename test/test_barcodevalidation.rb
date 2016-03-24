require 'minitest_helper'

class TestBarcodevalidation < MiniTest::Test
  def test_valid_barcodes
    [
      937179004167,
      '937179004167',
      9312631133233,
      '0753759137885',

      # the following are valid barcodes from upcdatabase.org
      '5000157024671',
      '4009993145602',
      '9006288060164',
      '045893058097',
      '5023274061190',
      '075720000715',
    ].each { |barcode| assert Barcodevalidation.valid?(barcode), barcode }
  end

  def test_invalid_barcodes
    [
      144793, #too short
      1234567890123, #invalid check digit
      50140424, #invalid check digit
      5420056646861,
      10004336,
      '48cm',
      123,
      1, #make sure only valid length barcodes are accepted
      22,
      333,
      4444,
      55555,
      666666,
      777777,
      99999999,
      12345678901,
      123456789012345,
      'BODGYBARCODE'
    ].each { |barcode| refute Barcodevalidation.valid?(barcode), barcode }
  end
end
