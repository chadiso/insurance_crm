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
