# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'barcodevalidation/version'

Gem::Specification.new do |spec|
  spec.name          = "barcodevalidation"
  spec.version       = Barcodevalidation::VERSION
  spec.authors       = ["Marketplacer"]
  spec.email         = ["it@marketplacer.com"]
  spec.summary       = %q{Barcode validation library}
  spec.description   = %q{Simple barcode validator. Just verifies that barcode checksum is valid}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
end
