# frozen_string_literal: true

require 'csv'

class Import::Csv::Parse
  attr_reader :import

  def initialize(import)
    raise 'No CSV attached to the import' unless import.csv.attached?

    @import = import
  end

  def call
    values = []

    parse_enumerator.each do |row|
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

  def parse_enumerator
    if Rails.env.production?
      CSV.parse(import.csv.download, headers: :first_row)
    else
      CSV.foreach(ActiveStorage::Blob.service.send(:path_for, import.csv.key), headers: true)
    end
  end

  def parse_date(str)
    Date.strptime(str, "%m/%d/%Y") rescue nil
  end
end
