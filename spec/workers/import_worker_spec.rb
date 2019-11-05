# frozen_string_literal: true

require 'spec_helper'

describe ImportWorker, type: :worker do
  it { is_expected.to be_processed_in :imports }
  it { is_expected.to be_retryable true }

  context 'with worker behaviour' do
    let(:args) { [777] }
    let(:time) { (Time.zone.today + 6.hours).to_datetime }
    let(:scheduled_job) { described_class.perform_at(time, args) }
    let(:queue) { 'imports' }

    before do
      Sidekiq::Testing.fake!
    end

    it 'ImportWorker jobs are enqueued in the scheduled queue' do
      described_class.perform_async
      assert_equal queue, described_class.queue
    end

    it 'goes into the jobs array for testing environment' do
      expect { described_class.perform_async(7) }.to change { described_class.jobs.size }.by(1)
      # described_class.new.perform(7)
      # Sidekiq::Worker.drain_all
    end

    context 'when occurs daily' do
      it 'occurs at expected time' do
        scheduled_job

        expect(described_class.jobs.last['jid']).to include(scheduled_job)
        expect(described_class).to have_enqueued_sidekiq_job(args)
      end
    end
  end

  context 'when inline' do
    before do
      Sidekiq::Testing.inline!
    end

    let!(:import) { create(:import, :with_5_customers) }

    it 'uses CSV parser' do
      allow(ImportCustomersBatchWorker).to receive(:perform_async)

      allow(Import::Csv::Parse).to receive(:new).with(import).and_call_original

      described_class.perform_async(import.id)

      expect(Import::Csv::Parse).to have_received(:new).with(import).once
    end

    it 'delegates row processing to the ImportCustomerWorker' do
      allow(ImportCustomersBatchWorker).to receive(:perform_async)

      described_class.perform_async(import.id)

      expect(ImportCustomersBatchWorker).to have_received(:perform_async).once
    end

    context 'when CSV parser called with some stubbed data' do
      let(:stub_customer_data_rows) { [{ first_name: 'ololo' }] }
      let(:csv_parser) { instance_double(Import::Csv::Parse) }

      before do
        allow(Import::Csv::Parse).to receive(:new).and_return(csv_parser)
        allow(csv_parser).to receive(:call).and_return(stub_customer_data_rows)
      end

      it 'delegates row processing to the ImportCustomerWorker with the same values' do
        allow(ImportCustomersBatchWorker).to receive(:perform_async)

        described_class.perform_async(import.id)

        expect(ImportCustomersBatchWorker).to have_received(:perform_async).with(import.id, [{first_name: 'ololo'}]).once
      end
    end
  end
end
