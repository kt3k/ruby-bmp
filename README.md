# Bmp v1.0.0

[![Gem Version](https://img.shields.io/gem/v/bmp.svg)](http://badge.fury.io/rb/bmp)
[![Build Status](https://img.shields.io/travis/kt3k/bmp.svg)](https://travis-ci.org/kt3k/bmp)
[![Coverage Status](https://img.shields.io/coveralls/kt3k/bmp.svg)](https://coveralls.io/r/kt3k/bmp)
[![Code Climate](https://img.shields.io/codeclimate/github/kt3k/bmp.svg)](https://codeclimate.com/github/kt3k/bmp)

> No hassle on bumping

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

Show current version info:
```
bmp [-i|--info]
```


bump patch (0.0.1) level:
```
bmp -p|--patch
```

This command updates all the version numbers which are specified in `.bmp.yml`


bump minor (0.1.0) level:
```
bmp -m|--minor
```


bump major (1.0.0) level:
```
bmp -j|--major
```


commit bump results
```
bmp -c|--commit
```

`bmp -c` commits all the changes now the repository has. Be careful.
And this command also tag it as `vX.Y.Z`.
