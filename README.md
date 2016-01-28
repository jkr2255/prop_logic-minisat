# PropLogic::Minisat
Using MiniSat solver to boost [PropLogic](https://github.com/jkr2255/prop_logic), to practical level.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'prop_logic-minisat'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install prop_logic-minisat

### for Windows users using MinGW Ruby (RubyInstaller & DevKit)
This gem uses [ruby-minisat](https://github.com/mame/ruby-minisat), which is hard to install in DevKit environment.

A modified edition of ruby-minisat for Windows is available in [jkr2255/ruby-minisat](https://github.com/jkr2255/ruby-minisat). You can use from Gemfile:

```ruby
gem 'ruby-minisat', github: 'jkr2255/ruby-minisat'
gem 'prop_logic-minisat'
```

## Usage
This gem internally require [PropLogic](https://github.com/jkr2255/prop_logic) gem, and automatically replaces `PropLogic.sat_sovler` to this gem's `PropLogic::Minisat::Solver`.

Once loaded, you can benefit from MiniSat speed without rewriting codes for PropLogic.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jkr2255/prop_logic-minisat.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

