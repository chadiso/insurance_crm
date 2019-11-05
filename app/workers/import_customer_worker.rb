# frozen_string_literal: true

class ImportCustomerWorker
  include Sidekiq::Worker

  sidekiq_options queue: "import_customers", retry: 0, max_retries: 0

  def perform(import_id, customer_data)
    import = Import.find_by(id: import_id)

    if import.present?
      # @todo: consider moving to the service
      customer = Customer.find_or_initialize_by(customer_data)
      return if customer.persisted? # no need to save it again

      customer.import = import
      if customer.save
        Import.transaction do
          import.with_lock do
            import.increment!(:imported_records_count)
          end
        end
      else
        puts "Couldn't import customer because of: #{customer.errors.full_messages.join("\r\n")}"
      end
    end
  end
end
