module Csv
  class Parser
    require 'csv'

    def initialize(path)
      begin
        @input_file = CSV.open(path)
      rescue => e
        raise ArgumentError.new(
           "Could not open CSV file at provided location. #{e}"
         )
      end
    end
  end
end
