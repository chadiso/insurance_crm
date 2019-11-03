class ImportWorker
  include Sidekiq::Worker

  sidekiq_options queue: 'imports', retry: true, max_retries: 5

  def perform(import_id)
    import = Import.find_by(id: import_id)
    unless import.present?
      puts "No import found for an id ##{import_id}. Skipping import job..."
      return
    end

    import.update_attribute(:status, 'started')

    values = Import::Csv::Parse.new(import).call

    import.update_column(:total_records_count, values.size)

    batch = Sidekiq::Batch.new
    batch.on(:complete, CompleteImportCallback, import_id: import.id)
    batch.jobs do
      values.each do |customer_data|
        ::ImportCustomerWorker.perform_async(import.id, customer_data)
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
      Import.where(id: import_id).update_all(status: 'completed')
      puts "All done. Import ##{import_id} completed!"
    end
  end
end
