# DependentOptionChecker

`dependent_option_checker` is a simple gem that provides a Rake task to detect missing `dependent` options in `has_many` / `has_one` associations in ActiveRecord models. It also helps identify missing `has_many` / `has_one` associations themselves.

## Features

- Detects associations lacking a dependent: ... option.
- Identifies missing has_many / has_one associations.
- Outputs the names of models and the specific missing configurations.
- Allows excluding specific tables from the check via a YAML config file.

## Installation

Add this line to your application's Gemfile:
```ruby
gem 'dependent_option_checker'
```

And then execute:
```console
bundle install

bin/rails g dependent_option_checker:install
```

This will generate a configuration file at config/dependent_option_checker.yml, which you can edit to specify tables to ignore during checks.

## Usage

Run the following command:

```console
bin/rails dependent_option_checker:check
```

If any missing configuration is detected, the task will output the corresponding model names and the details of what is missing.


## Configuration

You can create a `dependent_option_checker.yml` file in your Rails `config` directory to exclude specific tables and relations from the check:

```yaml
ignored_tables:
  - users

ignored_relations:
  Organization:
    - employees # alert: this is table name
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/muryoimpl/dependent_option_checker.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
