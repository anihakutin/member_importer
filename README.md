# MemberImporter

This importer will parse and format a csv input file.
Date fields will be validated and formatted according to the ISO8601 format.
Number fields will be validated and formatted according to the E.164 format.
A clean csv file will be saved to the output folder together with a report detailing the lines in error.

## Installation

Clone the repo to your local machine.

## Usage

Navigate into the repo and run `bin/console`.

Create a new csv parser specifying the input path for the csv file:

    $ input_file_path = File.expand_path('../../member_importer/data/input.csv', __FILE__)

    $ csv_parser = Csv::Parser.new(input_file_path)

Run parser by calling the parse method:

    $ csv_parser.parse

Your output will be available in the 'output' folder.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
