# frozen_string_literal: true

class ImportWorker
  IMPORT_BATCH_SIZE = 250

  include Sidekiq::Worker

  sidekiq_options queue: 'imports', retry: true, max_retries: 5

  def perform(import_id)
    import = Import.find_by(id: import_id)
    unless import.present?
      puts "No import found for an id ##{import_id}. Skipping import job..."
      return
    end

    import.update_columns(status: 'started', started_at: Time.now)

    values = Import::Csv::Parse.new(import).call

    import.update_columns(total_records_count: values.size, imported_records_count: 0)

    batch = Sidekiq::Batch.new
    batch.on(:complete, CompleteImportCallback, import_id: import.id)
    batch.jobs do
      values.in_groups_of(IMPORT_BATCH_SIZE, false) do |customer_data_chunk|
        ::ImportCustomersBatchWorker.perform_async(import.id, customer_data_chunk)
      end
    end
  end

  private

  class CompleteImportCallback
    # For Sidekiq::Batch callback
    def on_complete(status, options)
      puts "Import job completion triggered..."
      if status.failures.positive?
        puts "FAILURES: #{status.failures}"
        return
      end

      call(options)
    end

    def call(options)
      import_id = options.symbolize_keys[:import_id]
      Import.where(id: import_id).update_all(status: 'completed', completed_at: Time.now)

      puts "All done. Import ##{import_id} completed!"
    end
  end
end
