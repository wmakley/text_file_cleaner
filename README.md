# Text File Cleaner

Extractions of common text file processing functions, making use of iconv.
Typical uses include conversion from some charset to UTF-8, or stripping
non-UTF-8 characters when the source coding is unknown or mixed.

Uses the Open3.popen3 function to run iconv, and could probably be written to
be safer and more reliable. **Only use this library with trusted data.**

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'text_file_cleaner'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install text_file_cleaner

## Usage

Showing all arguments and their defaults:

    cleaner = TextFileCleaner.new(in_file, out_file, verbose: false, logger: nil)
    cleaner.iconv(from_code: "iso-8859-1", to_code: "utf-8", strip_unknown: false)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wmakley/text_file_cleaner.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
