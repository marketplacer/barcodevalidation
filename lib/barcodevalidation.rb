require "barcodevalidation/version"

module Barcodevalidation
  def self.valid?(barcode)
    Integer(barcode)

    parts = ('%018d' % barcode).to_s.chars.map(&:to_i)
    return false unless [8, 10, 12, 13].include?(barcode.to_s.length)
    checksum = parts.pop
    parts

    calculated_checksum = 0
    parts.each_with_index do |part, index|
      if index % 2 == 0
        calculated_checksum += (part * 3)
      else
        calculated_checksum += part
      end
    end

    calculated_checksum =  ((calculated_checksum.to_f / 10).ceil * 10) - calculated_checksum
    checksum == calculated_checksum

  rescue ArgumentError
    false #we only accept numeric barcodes
  end
end
