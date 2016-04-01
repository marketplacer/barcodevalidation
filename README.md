barcodevalidation
=================

[![Build Status][travis-badge]][travis]
[![Gem Version][rubygems-badge]][rubygems]

[travis]: <https://travis-ci.org/marketplacer/barcodevalidation>
[travis-badge]: <https://travis-ci.org/marketplacer/barcodevalidation.svg?branch=master>
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
# => #<BarcodeValidation::GTIN(937179004167)>
gtin.to_s        # => "937179004167"
gtin.valid?      # => true
gtin.check_digit # => #<BarcodeValidation::GTIN::CheckDigit(7)>
gtin.first(6)    # => #<BarcodeValidation::DigitSequence(937179)>
gtin.slice(0..5) # => #<BarcodeValidation::DigitSequence(937179)>

bad = BarcodeValidation.scan(937_179_004_162)
# => #<BarcodeValidation::GTIN(937179004162)>
bad.valid?               # => false
bad.check_digit          # => #<BarcodeValidation::GTIN::CheckDigit(2) invalid: expected 7>
bad.check_digit.valid?   # => false
bad.check_digit.actual   # => #<BarcodeValidation::Digit(2)>
bad.check_digit.expected # => #<BarcodeValidation::Digit(7)>
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



Continuous Integration
----------------------

Code is automatically tested with each push, on both Travis CI and
Marketplacer's internal Buildkite.



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
[LICENSE.md]: <https://github.com/marketplacer/barcodevalidation/blob/master/LICENSE.md>
