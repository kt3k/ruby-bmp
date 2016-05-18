# Bmp v1.3.1
[![Gem Version](https://img.shields.io/gem/v/bmp.svg)](http://badge.fury.io/rb/bmp)
[![Build Status](https://img.shields.io/travis/kt3k/bmp.svg)](https://travis-ci.org/kt3k/bmp)
[![Coverage Status](https://img.shields.io/coveralls/kt3k/bmp.svg)](https://coveralls.io/r/kt3k/bmp)
[![Code Climate](https://img.shields.io/codeclimate/github/kt3k/bmp.svg)](https://codeclimate.com/github/kt3k/bmp)

> No hassle on bumping

`bmp` command bumps and updates the version numbers in a repository according to the yaml file `.bmp.yml`. This is convenient if you have written many version numbers in your repository. This command helps you consistently update the version information in your repository.

## Install

```sh
gem install bmp
```

This install `bmp` command

## Usage

### `.bmp.yml` file

First you need to put `.bmp.yml` file on the top of your repository like the following:

```yml
---
version: 0.1.6
commit: Bump to version v%.%.%
files:
  gradle.properties: version=%.%.%
  README.md:
    - coveralls-gradle-plugin v%.%.%
    - org.kt3k.gradle.plugin:coveralls-gradle-plugin:%.%.%
```

`version` property is the current version number of the repository.

`commit` property is the commit comment of bump commits. This field is optional. The default is `Bump to version v%.%.%`.

`files` are the patterns of the files which contain version numbers in them. The key is the filename and value is the pattern containing the version number. `%.%.%` in the pettern string expresses the current vesion number.

Example:
```yml
gradle.properties: version=%.%.%
```

The expression above means the file `./gradle.properties` contains the pattern `version=0.1.6` (for now) and `%.%.%` part means the current version number (`0.1.6`) and it will be replaced in each version bumping.

You can set arrays of string to the value for a pattern. In that case, every string is considered as a separate pattern and all will be replaced with the next version in each bump

Example:
```yml
README.md:
  - coveralls-gradle-plugin v%.%.%
  - org.kt3k.gradle.plugin:coveralls-gradle-plugin:%.%.%
```

## The commands

### Info

Show current version info:
```
bmp [-i|--info]
```

This shows errors if exist. You can check the contents of `.bmp.yml` with this command.

### Bump

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


Add `preid`:
```
bmp --preid beta.1 # This performs 1.2.3 => 1.2.3-beta.1
```

Remove `preid` (which means you `release` it):
```
bmp --release
```

### Commit (and tag)

Commit bump results (and tag it):
```
bmp -c|--commit
```

`bmp -c` commits all the changes now the repository has. Be careful.
And this command also tag it as `vX.Y.Z`.

# History

- 2016-05-15   v1.2.0   Add commit property in `.bmp.yml`.

# License

MIT

# Development

## dev commands

### dependency download

    bundle install

### lint

    rake rubocop

### test

    rake spec

### install dev version

    rake install

### release

    rake release

## Domain models

Domain models are in `./lib/bump/domain` dir.

### VersionNumber

`VersionNumber` model represents the version number and bumps itself with levels.

### FileUpdateRule

`FileUpdateRule` model represents unit rule of version number replacement. A rule has a version number, a file path and a pattern for replacement.

### BumpInfo

`BumpInfo` model represents overall bumping strategy in a project. This model loosely corresponds to the contents of `.bmp.yml`.
