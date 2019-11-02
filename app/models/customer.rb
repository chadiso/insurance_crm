# == Schema Information
#
# Table name: customers
#
#  id         :integer          not null, primary key
#  first_name :string(255)
#  last_name  :string(255)
#  email      :string(255)
#  dob        :date
#  import_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_customers_on_import_id  (import_id)
#

class Customer < ApplicationRecord
  EMAIL_REGEXP = /\A[^@\s]+@[^@\s]+\z/.freeze

  belongs_to :import

  validates :first_name, presence: true, length: { minimum: 2 }
  validates :email, format: { with: EMAIL_REGEXP }
  validate :valid_age

  private

  def valid_age
    age = ((Time.zone.now - dob.to_time) / 1.year.seconds).floor if dob.present?

    errors.add(:base, 'Age must be between 18 and 100 year') unless (18..100).cover?(age)
  end
end
