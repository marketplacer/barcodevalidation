barcodevalidation
=================

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



Project Structure
-----------------

* `.bundle/config`: Configuration for Bundler
* `.ruby-version`: Gives rvm, rbenv, chruby etc. a Ruby version to use
* `Gemfile`: Lists RubyGem dependencies, to be installed by Bundler
* `bin/`: Contains binstubs, useful for development tasks
    * `bundle`: Runs Bundler, in the correct way
    * `setup`: Sets up the project to be ready for development
* `config/boot.rb`: Prepares dependencies before loading the library



License
-------

This project is licensed under the [MIT License]. See [LICENSE.md] for
the full text.

[MIT License]: <https://opensource.org/licenses/MIT>
[LICENSE.md]: <https://github.com/marketplacer/barcodevalidation/blob/master/LICENSE.md>
