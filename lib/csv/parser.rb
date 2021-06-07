module Csv
  class Parser
    require 'csv'

    def initialize(path)
      begin
        @input_file = CSV.open(path)
      rescue => e
        raise ArgumentError.new(
           "Could not open CSV file with the provided path. #{e}"
         )
      end
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

      return "+1" + formatted_number if formatted_number.length == 10
      return "+" + formatted_number if formatted_number.length == 11
    end
  end
end
