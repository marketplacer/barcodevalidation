lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "barcodevalidation/version"

Gem::Specification.new do |spec|
  spec.name          = "barcodevalidation"
  spec.version       = BarcodeValidation::VERSION
  spec.authors       = ["Marketplacer"]
  spec.email         = ["it@marketplacer.com"]

  spec.summary       = "Parses and validates barcodes"
  spec.description   = "A RubyGem to parse and validate barcodes"
  spec.homepage      = "https://github.com/marketplacer/#{spec.name}"
  spec.license       = "MIT"

  spec.files         = %w[LICENSE.md README.md barcodevalidation.gemspec
                          config/*.rb lib/**/*.rb]
                       .flat_map { |pattern| Dir.glob(pattern) }
                       .reject { |f| File.directory?(f) }
  spec.bindir        = "exe"
  spec.executables   = spec.files
                           .grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "adamantium"
end
