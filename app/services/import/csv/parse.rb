require 'csv'

class Import::Csv::Parse
  attr_reader :import

  def initialize(import)
    raise 'No CSV attached to the import' unless import.csv.attached?

    @import = import
  end

  def call
    values = []

    CSV.foreach(file_path, headers: true) do |row|
      values << {
        # @todo: could be refactored to some Mapper
        first_name: row['first_name'],
        last_name: row['last_name'],
        email: row['email'],
        dob: parse_date(row['date_of_birth'])
      }
    end

    values
  end

  private

  def file_path
    @file_path ||= ActiveStorage::Blob.service.send(:path_for, import.csv.key) # import.csv.download
  end

  def parse_date(str)
    Date.strptime(str, "%m/%d/%Y") rescue nil
  end
end
