# frozen_string_literal: true

require 'spec_helper'

describe ImportCustomerWorker, type: :worker do
  it { is_expected.to be_processed_in :import_customers }
  it { is_expected.to be_retryable 0 }

  context 'when inline' do
    before do
      Sidekiq::Testing.inline!
    end

    context 'with created import and valid data hash' do
      subject(:job) { described_class.perform_async(import.id, stub_customer_data_row) }

      let(:stub_customer_data_row) do
        {
          first_name: 'first_name',
          last_name: 'last_name',
          email: 'ololo@gmail.com',
          dob: "2001-10-01 00:00:00 UTC"
        }
      end

      let!(:import) { create(:import) }

      it 'imports record to the db' do
        expect { job }.to change(Customer, :count).by(1)
      end

      it 'assigns correct import reference for the customer' do
        subject

        expect(Customer.last.import).to eq(import)
      end

      it 'increments imported_records_count counter' do
        expect { job }.to change { import.reload.imported_records_count }.by(1)
      end
    end
  end
end
