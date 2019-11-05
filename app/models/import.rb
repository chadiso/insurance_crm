# frozen_string_literal: true

# == Schema Information
#
# Table name: imports
#
#  id                     :integer          not null, primary key
#  status                 :string(255)      default("created"), not null
#  started_at             :datetime
#  completed_at           :datetime
#  total_records_count    :integer          default("0"), not null
#  imported_records_count :integer          default("0"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_imports_on_status  (status)
#

class Import < ApplicationRecord
  STATUSES = %w[created started completed].freeze

  has_many :customers
  has_one_attached :csv

  validates :status, inclusion: { in: STATUSES }, allow_nil: true
end
