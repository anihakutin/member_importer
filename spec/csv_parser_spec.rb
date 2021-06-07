RSpec.describe Csv::Parser do
  path = File.expand_path('../../data/input.csv', __FILE__)

  it "instantiates a csv parser with a csv file" do
    csv_parser = Csv::Parser.new(path)

    expect(csv_parser).to be_an_instance_of(Csv::Parser)
  end

  it "rejects rows where not all values are present" do
    csv_parser = Csv::Parser.new(path)
    invalid_data_row = ['Jason','Bateman ','12/12/2010','AB 0000','','','']

    expect(csv_parser.is_row_valid?(invalid_data_row)).to eq(false)
  end

  it "accepts rows where all values are present" do
    csv_parser = Csv::Parser.new(path)
    valid_data_row = [
      'Antonio',
      'Brown ',
      '2/2/1966',
      '890887',
      '9/30/19',
      '9/30/2000',
      '303-333-9987'
    ]

    expect(csv_parser.is_row_valid?(valid_data_row)).to eq(true)
  end
end
