# DocxAnon

Docx Anonymization. This gem has one simple goal, to anonymize a docx file.
It's also written in a way that should be easy to extend


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'docx_anon'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install docx_anon

## Usage

```ruby
DocxAnon.clean("path/to/file/manuscript.docx")
=> "path/to/file/sanitized/manuscript.docx"
```

#### Specify where the file is written
By default the file is written along side the original file but within a sanitized folder.  You can also specify the location and filename by supplying a `file_path`
```ruby
DocxAnon.clean("path/to/file/manuscript.docx", file_path: "/tmp/sanitized-manuscript.docx"
=> "/tmp/sanitized-manuscript.docx"
```
#### Specify output_dir
You can also globally specify the directory files will be written to.

### Sanitizers

You can write new santizers. (see the sanitizer [README](./lib/docx_anon/sanitizers/README.md) for more info.

### Disable Sanitizers

You can disable any sanitizer with the `disabled_sanitizers` config option.
This option is an array with the sanitizers `FILE_HANDLER` value as a string.

These are all the current existing FILE_HANDLERs
* `docProps/app.xml`
* `word/comments.xml`
* `docProps/core.xml`

```ruby
DocxAnon.configure { |c| c.disabled_sanitizers = [ "word/comments.xml" ] }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tatums/docx_anon.
