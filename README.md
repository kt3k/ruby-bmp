# Bump v0.0.1

> Bump version info in a repository

## Installation

```sh
git clone git@github.com:kt3k/bump.git
cd bump
gem build bump.gemspec
gem install bump-0.1.0.gem
```

## Usage

bump patch (0.0.1) level:
```
bump -s
```

bump minor (0.1.0) level:
```
bump -m
```

bump major (1.0.0) level:
```
bump -l
```

commit diffs with bump comment:
```
bump -f
```


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
