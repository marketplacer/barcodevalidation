barcodevalidation
=================

[![Build Status][travis-badge]][travis]

[travis]: <https://travis-ci.org/marketplacer/barcodevalidation>
[travis-badge]: <https://travis-ci.org/marketplacer/barcodevalidation.svg?branch=master>

A RubyGem to parse and validate barcodes.



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
