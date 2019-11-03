class Import
  class Create
    attr_reader :csv_file

    def initialize(params)
      @csv_file = params[:csv]
    end

    def call
      import = Import.create(import_create_params)
      import.csv.attach(csv_file)

      import
    end

    private

    def import_create_params
      {
        status: 'created'
      }
    end
  end
end
