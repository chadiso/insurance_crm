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

FactoryBot.define do
  factory :import do
    status { 'created' }
  end
end
