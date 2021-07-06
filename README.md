# Semvruler

Provides some utility classes to read, compare and match [semantic versions](https://semver.org/).

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

### Creating versions 

```ruby

    # Creates and destructure version string
    version = Semvruler.version('2.2.5-pr.0')

    version.major # => 2 
    version.minor # => 2 
    version.patch # => 5
    version.build # => nil
    version.prerelease # => ['pr','0']

    # You can put back together the original string
    version.to_s # => '2.2.5-pr.0'

    # Returns an array when multiple versions passed
    versions = Semvruler.versions(['3.4.5', '2.2.5', '1.1.1', '1.1.1-pr.0'])
```

### Comparable versions

Versions implement ruby's comparable interface and '~>' operator as well.

```ruby
    versions = Semvruler.versions(['3.4.5', '2.2.5', '1.1.1', '1.1.1-pr.0'])
    versions.sort # => ["1.1.1-pr.0", "1.1.1", "2.2.5", "3.4.5"]

    ver1 = version[0]
    ver2 = version[1]

    ver1 != ver2 # => true
    ver1 == ver2 # => false
    ver1 > ver2 # => true
    ver1 >= ver2 # => true
    ver1 < ver2 # => false
    ver1 <= ver2 # => false
```

### Rules instantiation

```ruby
    rule = Semvruler.rule('~> 2.0.2')
    rule.to_s # => '~> 2.0.2'

    # Rules can be adjusted
    rule.add('< 10.0.1')
    rule.remove('< 10.0.1')
    rule.merge(rule2)
```

### Rules Matching

```ruby
    rule = Semvruler.rule('!= 2.0.2')
    rule.match?('2.0.2') # => false
    rule.match?('2.3.2') # => true

    # Rules respond to to_proc
    rule = Semvruler.rule('~> 2.0')
    ['3.2.1', '1.2.3', '2.1.1'].find(&rule) # => '2.1.1'
    ['3.2.1', '1.2.3', '2.1.1'].select(&rule) # => ['2.1.1']
    ['3.2.1', '1.2.3', '2.1.1'].reject(&rule) # => ['3.2.1', '1.2.3']
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nika-kirosh/semvruler

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
