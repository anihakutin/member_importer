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
  end
end
