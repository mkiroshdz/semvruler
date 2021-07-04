# Semvruler

Semvruler is a utility to match and compare semantic versions in ruby that manage versions as value objects and allows to create rules.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'semvruler'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install semvruler

## Usage

```
    rule = Semvruler.rule('~>2.0.2')
    rule2 = Semvruler.rule('~>2.3.2')
    version = Semvruler.version('2.2.5')
    version2 = Semvruler.version('2.2.5')

    version.major
    version.minor
    version.patch
    version.build
    version.prerelease

    [version, version2].sort
    [version, version2].find(rule)

    rule3 = rule.union(rule2)
    rule4 = rule.intersec(rule2)

    rule.match(version)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nika-kirosh/semvruler

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
