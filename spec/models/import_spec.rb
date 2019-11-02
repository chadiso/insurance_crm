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

    describe 'validations' do
      it { is_expected.to validate_inclusion_of(:status).in_array(%w[created started completed]).allow_nil }
    end

    describe 'defaults' do
      it 'sets status to :created by default' do
        expect(subject.status).to eq('created')
      end
    end
  end
end
