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

require 'rails_helper'

RSpec.describe Customer, type: :model do
  before { Timecop.freeze("2019-11-01 00:00:00 UTC") }

  after { Timecop.return }

  describe 'associations' do
    it { is_expected.to belong_to(:import) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_length_of(:first_name).is_at_least(2) }

    context 'when email' do
      subject(:customer) { build(:customer) }

      it { is_expected.to be_valid }

      it 'is not valid' do
        customer.email = 'ololo'
        expect(customer).not_to be_valid
      end

      it 'is valid' do
        customer.email = 'ololo@gmail.com'
        expect(customer).to be_valid
      end
    end

    context 'when dob' do
      subject(:customer) { build(:customer, dob: "2001-11-02 00:00:00 UTC") } # 17 years old from now (2019-11-01)

      it 'is not valid' do
        expect(customer).not_to be_valid
      end
    end
  end
end
