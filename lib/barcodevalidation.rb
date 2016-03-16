require "barcodevalidation/version"

module Barcodevalidation
  def self.valid?(barcode)
    barcode = barcode.to_s
    return false unless [8, 10, 12, 13].include?(barcode.length)

    parts = barcode.rjust(18, '0').chars.map(&:to_i)
    checksum = parts.pop

    calculated_checksum = 0
    parts.each_with_index do |part, index|
      if index % 2 == 0
        calculated_checksum += (part * 3)
      else
        calculated_checksum += part
      end
    end

    calculated_checksum = ((calculated_checksum.to_f / 10).ceil * 10) - calculated_checksum
    checksum == calculated_checksum

  rescue ArgumentError
    false #we only accept numeric barcodes
  end
end
