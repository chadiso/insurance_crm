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
#  index_customers_on_email      (email) UNIQUE
#  index_customers_on_import_id  (import_id)
#

FactoryBot.define do
  factory :customer do
    import

    first_name { 'John' }
    last_name { 'Doe' }
    email { Faker::Internet.email }
    dob { Date.today - 19.years }
  end
end
