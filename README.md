barcodevalidation
=================

[![Build Status][ci-badge]][ci]
[![Gem Version][rubygems-badge]][rubygems]

[ci]: <https://buildkite.com/marketplacer/barcodevalidation>
[ci-badge]: <https://badge.buildkite.com/d0d578653bc319cd41e9adb2ac23f1c0d59cf56ee6cc329d78.svg?branch=main>
[rubygems]: <https://badge.fury.io/rb/barcodevalidation>
[rubygems-badge]: <https://badge.fury.io/rb/barcodevalidation.svg>

A RubyGem to parse and validate barcodes.



Installation
------------

Add this line to your application's Gemfile:

```ruby
gem "barcodevalidation"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install barcodevalidation



Usage
-----

The main API is `BarcodeValidation.scan`. It accepts a single argument,
and it's pretty flexible about what you give it.

```ruby
gtin = BarcodeValidation.scan("937179-004167")
# => #<BarcodeValidation::GTIN::GTIN12(937179004167)>
gtin.to_s        # => "937179004167"
gtin.valid?      # => true
gtin.check_digit # => #<BarcodeValidation::GTIN::CheckDigit(7)>
gtin.first(6)    # => #<BarcodeValidation::DigitSequence(937179)>
gtin.slice(0..5) # => #<BarcodeValidation::DigitSequence(937179)>
gtin.to_gtin_13  # => #<BarcodeValidation::GTIN::GTIN13(0937179004167)>
gtin.to_all_valid
# => [#<BarcodeValidation::GTIN::GTIN12(937179004167)>,
#<BarcodeValidation::GTIN::GTIN123(0937179004167)>]

bad = BarcodeValidation.scan(937_179_004_162)
# => #<BarcodeValidation::InvalidGTIN(937179004162)>
bad.valid?               # => false
bad.check_digit          # => #<BarcodeValidation::GTIN::CheckDigit(2) invalid: expected 7>
bad.check_digit.valid?   # => false
bad.check_digit.actual   # => #<BarcodeValidation::Digit(2)>
bad.check_digit.expected # => #<BarcodeValidation::Digit(7)>
bad.to_gtin_13           # => #<BarcodeValidation::InvalidGTIN(937179004162)>
bad.to_all_valid         # => []
```


Custom GTINs
------------

If the standard GTINs provided are not enough for your needs, you can implement your own and register it.
`BarcodeValidation::GTIN.gtin_classes` contains the ordered list of GTIN classes that are checked if they `handle?(input)`.
Add your own class to the list, or remove default ones, to tailor it to your needs. For example:

```ruby
# A custom class that handles any length GTIN as long as it starts with "123".
# Note that we must still provide a VALID_LENGTH to allow transcoding to other GTINs by zero-padding.
class MyCustomGTIN < BarcodeValidation::GTIN::Base
  VALID_LENGTH = 20

  def self.handles?(input)
    input.start_with?("123") && input.length <= VALID_LENGTH
  end

  # Custom validity check
  def valid?
    self.class.handles?(input) && check_digit.valid?
  end
end

BarcodeValidation::GTIN.gtin_classes.unshift MyCustomGTIN
```


Development
-----------

Download the code from GitHub:

```
git clone git@github.com:marketplacer/barcodevalidation.git
```

Set up dependencies using Bundler:

```
cd barcodevalidation
bin/setup
```

Start the interactive development console:

```
bin/console
```

Run a build:

```
bin/rake
```

#### Code Quality Checks

Rubocop is used to enforce coding standards.

```
bin/rubocop
bin/rubocop --help
```



Tests & Publishing
----------------------

Code is automatically tested with each push on Buildkite. Assuming all tests pass, commits on `main` will be parsed with [Semantic Release](https://github.com/semantic-release/semantic-release) to produce new Git tags, and to publish to RubyGems.



Project Structure
-----------------
This project's structure is inspired by the Bundler skeleton for a new
Gem, created using `bundler gem barcodevalidation`.

* `.bundle/config`: Configuration for Bundler
* `.ruby-version`: Gives rvm, rbenv, chruby etc. a Ruby version to use
* `Gemfile`: Lists RubyGem dependencies, to be installed by Bundler
* `Rakefile`: Defines Rake tasks
* `bin/`: Contains binstubs, useful for development tasks
    * `bundle`: Runs Bundler, in the correct way
    * `console`: development console (equiv. to `bin/bundle exec pry`)
    * `rake`: Runs Rake (equivalent to `bin/bundle exec rake`)
    * `rubocop`: Runs Rubocop (equivalent to `bin/bundle exec rubocop`)
    * `setup`: Sets up the project to be ready for development
* `config/boot.rb`: Prepares dependencies before loading the library
* `lib/`: Source files; this directory is added to Ruby's load path
* `script/ci`: The script run by Buildkite to start a build



License
-------

This project is licensed under the [MIT License]. See [LICENSE.md] for
the full text.

[MIT License]: <https://opensource.org/licenses/MIT>
[LICENSE.md]: <https://github.com/marketplacer/barcodevalidation/blob/main/LICENSE.md>
