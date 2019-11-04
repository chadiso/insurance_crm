class ImportCustomersBatchWorker
  include Sidekiq::Worker

  sidekiq_options queue: "import_customers", retry: 0, max_retries: 0

  def perform(import_id, customers_data)
    import = Import.find(import_id)

    # assign for a proper import record
    customers_data.map! { |c| c[:import_id] = import.id; c }

    result = Customer.import(
      customers_data,
      validate: true,
      # validate_uniqueness: true,
      # ignore: true,
      on_duplicate_key_ignore: true
      # on_duplicate_key_update: [:email]
    )

    # logger.info "Result of import ##{import_id} with #{customers_data.size} data chunk(s):\r\n: #{customers_data.inspect} \r\n"
    # logger.debug result.inspect

    # upd counter in the imports table
    imported_records_count = customers_data.size - result.failed_instances.size
    Import.transaction do
      import.with_lock do
        import.increment!(:imported_records_count, imported_records_count)
      end
    end
  end
end
