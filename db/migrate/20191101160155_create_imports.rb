class CreateImports < ActiveRecord::Migration[5.2]
  def change
    create_table :imports do |t|
      t.string :status, default: 'created', null: false, index: true
      t.datetime :started_at
      t.datetime :completed_at
      t.integer :total_records_count, default: 0, null: false
      t.integer :imported_records_count, default: 0, null: false

      t.timestamps
    end
  end
end
