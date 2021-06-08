module Csv
  class Parser
    require 'csv'
    require 'date'

    REQUIRED_HEADER = [
      'last_name',
      'first_name',
      'dob',
      'member_id',
      'effective_date',
      'expiry_date',
      'phone_number'
    ]

    def initialize(path)
      begin
        @input_file = CSV.open(path)
      rescue => e
        raise ArgumentError.new(
           "Could not open CSV file with the provided path. #{e}"
         )
      end
    end

    def parse
      valid_rows = []
      invalid_rows = []

      header_row = @input_file[0]

      if is_header_valid?(header_row)
        @input_file.shift.each_with_index do |row, i|
          error_messages = []

          error_messages << "has missing required values." unless is_row_valid?(row)
          error_messages << "has an invalid date." unless is_date_valid?(row[2])
          error_messages << "has an invalid date." unless is_date_valid?(row[4])
          error_messages << "has an invalid date." unless is_date_valid?(row[5])
          error_messages << "has an invalid phone number." unless is_phone_valid?(row[6])

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

      return REQUIRED_HEADER == header_row
    end

    def is_row_valid?(row)
      return false unless row && row.kind_of?(Array)
      return false if row.any? { |v| v.nil? || v.strip.empty? }

      return true
    end

    def is_phone_valid?(phone_number)
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
      begin
        Date.parse(date).strftime('%F')

        return true
      rescue
        return false
      end
    end

    def format_date(date)
      return Date.parse(date).strftime('%F')
    end

    def write_csv(rows)

    end

    def write_report(rows)

    end
  end
end
