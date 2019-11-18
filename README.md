# Bundler::Dependencies

Inspect dependencies for gems.

## Commands

### Count

Check how many dependencies each gem in the Gemfile has (use the `--minimum N` switch to limit the output to gems with at least `N` dependencies):

```sh
bundle dependencies [count] [--minimum N] 
```

### Graph

See a graph of all dependencies:
```sh
bundle dependencies graph
```

See a graph of all dependencies for a specific gem:
```sh
bundle dependencies graph GEMNAME
```

### Command Options

* `--path PATH`: User the Gemfile for the project at `PATH`, rather than the current project's Gemfile.
* `--without foo bar baz`/`-W foo bar baz`: Exclude the listed gems from the scan. Any uses either directly in your Gemfile or as dependencies will be excluded, and not be counted.
* `--without-rails`/`-R`: Quick option to exclude all 1st party Rails gems from the scan.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dvandersluis/bundler-dependencies.
