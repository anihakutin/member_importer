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

  it "returns true if phone number is valid" do
    csv_parser = Csv::Parser.new(path)
    phone_number = '303-333-9987'
    valid = csv_parser.is_phone_valid?(phone_number)

    expect(valid).to eq(true)
  end

  it "transforms valid phone numbers to E.164 US format" do
    csv_parser = Csv::Parser.new(path)
    valid_number = '303-333-9987'
    formatted_number = csv_parser.format_phone_number(valid_number)

    expect(formatted_number).to match('^\+?\d{11}$')
  end
end
