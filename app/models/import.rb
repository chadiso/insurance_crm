# == Schema Information
#
# Table name: imports
#
#  id                     :integer          not null, primary key
#  status                 :string(255)
#  started_at             :datetime
#  completed_at           :datetime
#  total_records_count    :integer
#  imported_records_count :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Import < ApplicationRecord
  STATUSES = %w[created started completed].freeze

  has_many :customers
  has_one_attached :csv

  validates :status, inclusion: { in: STATUSES }, allow_nil: true
end
