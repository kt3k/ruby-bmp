# Bmp v0.8.1

[![Gem Version](https://badge.fury.io/rb/bmp.png)](http://badge.fury.io/rb/bmp)
[![Build Status](https://travis-ci.org/kt3k/bmp.png)](https://travis-ci.org/kt3k/bmp)
[![Coverage Status](https://coveralls.io/repos/kt3k/bmp/badge.png)](https://coveralls.io/r/kt3k/bmp)
[![Code Climate](https://codeclimate.com/github/kt3k/bmp.png)](https://codeclimate.com/github/kt3k/bmp)

> Bump and update version numbers in a repository

`bmp` command bumps and updates the version numbers in a repository according to the yaml file `.bmp.yml`. This is convenient if you have written many version numbers in your repository. This command helps you consistently update the version information in your repository.

## Installation

```sh
gem install bmp
```

This install `bmp` command

## Usage

### `.bmp.yml` version description file

put `.bmp.yml` file on the top of your repository like following:

```
---
version: 0.1.6
files:
  gradle.properties: version=%.%.%
  README.md:
  - coveralls-gradle-plugin v%.%.%
  - org.kt3k.gradle.plugin:coveralls-gradle-plugin:%.%.%
```

`version` value is the current version number of the repository.

`files` are the mappings of the files which contain version numbers in them.

```
gradle.properties: version=%.%.%
```

The expression above means the file `./gradle.properties` contains the string `version=0.1.6` (because the current version is 0.1.6) and `%.%.%` is the placeholder for current version number and will updated on version bumps.

### bmp command

show current version info:
```
bmp --info
```


bump patch (0.0.1) level:
```
bmp --patch
```


bump minor (0.1.0) level:
```
bmp --minor
```


bump major (1.0.0) level:
```
bmp --major
```


commit bump results
```
bmp --commit
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
