# jekyll-js-converter

[![Build Status](https://travis-ci.com/dsusco/jekyll-js-converter.svg?branch=main)](https://travis-ci.com/dsusco/jekyll-js-converter) [![Gem Version](https://badge.fury.io/rb/jekyll-js-converter.svg)](https://badge.fury.io/rb/jekyll-js-converter)

A JavaScript converter for Jekyll. JavaScript files can be concatenated using special comments and then minified using [Uglifier](https://github.com/lautis/uglifier).

## Installation

Add the gem to the `jekyll_plugins` group in the site's Gemfile:

    group :jekyll_plugins do
      gem 'jekyll-js-converter'
    end

And then bundle:

    $ bundle

## Usage

Add front matter to the JavaScript files which jekyll-js-converter needs to convert (e.g. the main JavaScript file for the site like `assets/js/my-site.js`). Three directives can then be used to add the contents of other JavaScript files to the file being converted. Note that these other files can use the directives too, but do not need front matter however (think of them as "partials").

    ---
    ---
    //= import <SOME_FILE>
    //= import_directory <SOME_DIRECTORY>
    //= import_tree <SOME_DIRECTORY>

    console.log('This file has been converted by jekyll-js-converter!')

By default, jekyll-js-converter will look for the files and directories to import in the site's `_javascript` folder as well as the theme's `_javascript` folder (if one is present). It can also be configured with additional load paths as well (see Configuration).

  * `import` adds the contents of the given file (either a local file or a URI)
  * `import_directory` adds the contents of each `.js` file in the given directory
  * `import_tree` adds the contents of all `.js` files in all directories of the given directory

## Configuration

Configuration options are added to the `_config.yml` file like this:

    javascript:
      ...

The options are:

### `javascript_dir`

The path (relative to the site's `source` option) of the directory which contains the JavaScript "partials".

Defaults to `_javascript`.

### `load_paths`

Additional paths (relative to the site's `source` option) to search for JavaScript "partials" in. These should be given as an array.

Defaults to `[]`.

### `source_map`

Whether a `.map.js` file should be created or not. Valid values are:

  * `always`:  map files will be created
  * `never`:  no map files will be created
  * `development`:  map files will be created if the site is generated with `JEKYLL_ENV='development'`

Defaults to `always`.

### `uglifier`

Options to pass to `Uglifier.new` which is then used to compile the JavaScript.

Defaults to `{}`.

## Contributing

1. Fork `https://github.com/dsusco/jekyll-js-converter`
2. Create a branch (`git checkout -b new-feature`)
3. Commit the changes (`git commit -am 'Added a new feature'`)
4. Push the branch (`git push origin new-feature`)
5. Create a pull request
