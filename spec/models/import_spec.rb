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

require 'rails_helper'

RSpec.describe Import, type: :model do
  describe "associations" do
    it { should have_many(:customers) }
  end

  it { expect(subject.csv).to be_an_instance_of(ActiveStorage::Attached::One)}

  describe "attachments" do
    subject(:import) { build(:import, :with_5_customers) }

    it 'attaches a csv file with 5 customers' do
      expect(import.csv.attached?).to be_truthy
      expect(import.csv.filename.to_s).to eq('5_customers.csv')
      expect(import.csv.content_type).to eq('text/csv')
    end
  end

  describe 'validations' do
    it { is_expected.to validate_inclusion_of(:status).in_array(%w[created started completed]).allow_nil }
  end

  describe 'defaults' do
    it 'sets status to :created by default' do
      expect(subject.status).to eq('created')
    end
  end
end
