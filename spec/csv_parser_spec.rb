RSpec.describe Csv::Parser do
  it "instantiates a csv parser with a csv file" do

    path = File.expand_path('../data/input.csv', __FILE__)
    csv_parser = Csv::Parser.new(path)

    expect(csv_parser).to be_an_instance_of(Csv::Parser)
  end
end
