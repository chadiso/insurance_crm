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

FactoryBot.define do
  factory :import do
    # status { 'created' }
  end

  trait :with_5_customers do
    after(:build) do |import|
      import.csv.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'csvs', '5_customers.csv')),
        filename: '5_customers.csv'
        # content_type: 'attachment/csv'
      )
    end
  end

  trait :with_500_customers do
    after(:build) do |import|
      import.csv.attach(
        io: File.open(Rails.root.join('spec', 'fixtures', 'csvs', '500_customers.csv')),
        filename: '5_customers.csv'
      )
    end
  end
end
