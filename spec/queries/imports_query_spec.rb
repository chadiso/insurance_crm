# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportsQuery, type: :model do
  context '#results' do
    subject(:results) { described_class.new(params).results }

    let(:params) { {} }

    before { Timecop.freeze("2019-11-01 00:00:00 UTC") }

    after { Timecop.return }

    context 'when no filters applied' do
      let!(:import) { create :import }

      it 'returns correct collection result' do
        expect(results).to eq([import])
      end
    end

    context 'when order applied' do
      let!(:import1) { create :import, created_at: Time.current }
      let!(:import2) { create :import, created_at: Time.current + 1.hour }
      let!(:import3) { create :import, created_at: Time.current + 2.hours }

      context 'with created_at by default' do
        it 'returns correct collection result' do
          expect(results.to_a).to eq([import3, import2, import1])
        end
      end
    end

    context 'when page applied' do
      let(:params) { { page: 3 } }

      before { create_list :import, 22 }

      it 'returns correct collection result' do
        expect(results.to_a.count).to eq(2)
      end
    end
  end
end
