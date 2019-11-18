# Bundler::Dependencies

Inspect dependencies for gems.

## Usage

Check how many dependencies each gem in the Gemfile has:

```sh
bundle dependencies count [--min N] 
```

See a graph of all dependencies:
```sh
bundle dependencies graph
```

See a graph of all dependencies for a specific gem:
```sh
bundle dependencies graph GEMNAME
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dvandersluis/bundler-dependencies.
