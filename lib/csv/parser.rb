module Csv
  class Parser
    require 'csv'
    require 'date'
    require 'pry'

    def initialize(path)
      begin
        @input_file = CSV.open(path)
      rescue => e
        raise ArgumentError.new(
           "Could not open CSV file with the provided path. #{e}"
         )
      end

      @required_header = [
        'first_name',
        'last_name',
        'dob',
        'member_id',
        'effective_date',
        'expiry_date',
        'phone_number'
      ]

      @output_header= [
        'last_name',
        'first_name',
        'dob',
        'member_id',
        'effective_date',
        'expiry_date',
        'phone_number'
      ]
    end

    def parse
      valid_rows = []
      invalid_rows = []

      csv_rows = @input_file.each.to_a.compact
      header_row = csv_rows[0]

      if is_header_valid?(header_row)
        csv_rows.each_with_index do |row, i|
          # skip header
          next if i == 0

          error_messages = []

          error_messages << "Missing required values." unless is_row_valid?(row)
          error_messages << "Column '#{@required_header[2]}' has an invalid date." unless is_date_valid?(row[2])
          error_messages << "Column '#{@required_header[4]}' has an invalid date." unless is_date_valid?(row[4])
          error_messages << "Column '#{@required_header[5]}' has an invalid date." unless is_date_valid?(row[5])
          error_messages << "Column '#{@required_header[6]}' has an invalid phone number." unless is_phone_valid?(row[6])

          valid_rows << row if error_messages.empty?
          invalid_rows << [i, error_messages] if error_messages.any?
        end
      else
        invalid_rows << [0, ["Header row is invalid."]]
      end

      write_csv(valid_rows)
      write_report(invalid_rows)
    end

    def is_header_valid?(header_row)
      return false if header_row.empty?

      return @required_header.difference(header_row).any?
    end

    def is_row_valid?(row)
      return false unless row && row.kind_of?(Array)
      return false if row.any? { |v| v.nil? || v.strip.empty? }

      return true
    end

    def is_phone_valid?(phone_number)
      return false if phone_number.nil? || phone_number.empty?

      formatted_number = phone_number.gsub(/([-+() ])/, '')

      return true if [10, 11].include?(formatted_number.length)

      return false
    end

    def format_phone_number(phone_number)
      formatted_number = phone_number.gsub(/([-+() ])/, '')

      return "+1" + formatted_number if formatted_number.length <= 10
      return "+" + formatted_number if formatted_number.length <= 11
    end

    def is_date_valid?(date)
      return false if date.nil? || date.empty?
      counter = 0

      begin
        counter += 1

        if counter > 1
          date_str = convert_two_digit_year(date)
          new_date = Date.strptime(date_str, '%m/%d/%Y')
          new_date.strftime('%F')
        else
          Date.parse(date).strftime('%F')
        end

        return true
      rescue
        retry if counter < 2
      else
        return false
      end
    end

    def convert_two_digit_year(date)
      year = date.split("/").last.to_i
      year += 2000 if (0..29).include?(year)
      year += 1900 if (30..99).include?(year)

      new_date = date.split("/")
      new_date[2] = year

      return new_date.join("/")
    end

    def format_date(date)
      begin
        Date.parse(date).strftime('%F')
      rescue
        date_str = convert_two_digit_year(date)
        new_date = Date.strptime(date_str, '%m/%d/%Y')
        new_date.strftime('%F')
      end
    end

    def write_csv(rows)
      return if rows.empty?

      formatted_rows = []
      rows.each do |row|
        # Put the last name first
        row[0], row[1] = row[1], row[0]

        # Format dates
        [2, 4, 5].each { |i| row[i] = format_date(row[i]) }

        # Format phone number
        row[6] = format_phone_number(row[6])

        # Remove extra whitespace
        formatted_rows << row.each.map(&:strip)
      end

      CSV.open("output/export.csv", "wb") do |csv|
        csv << @output_header
        formatted_rows.each { |row| csv << row }
      end
    end

    def write_report(rows)
      return if rows.empty?

      File.open("output/report.txt", "w") do |file|
        rows.each { |row| file.write "Row ##{row[0]} errors: #{row[1].join(" ")}\n" }
      end
    end
  end
end
