# Bmp v0.3.0

> Bump version info in a repository

## Installation

```sh
gem install bmp
```

This install `bmp` command

## Usage

### version descriptor

put `.version` file on the top of your repository like following (which is `YAML`):

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

### bump command

bump patch (0.0.1) level:
```
bmp -p
```

bump minor (0.1.0) level:
```
bmp -m
```

bump major (1.0.0) level:
```
bmp -j
```

commit diffs with bump comment:
```
bmp -f
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
