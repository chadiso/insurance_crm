# frozen_string_literal: true

class RemoveImportIdFkFromCustomers < ActiveRecord::Migration[5.2]
  def up
    remove_foreign_key :customers, :imports
  end

  def down
    add_foreign_key :customers, :imports
  end
end
