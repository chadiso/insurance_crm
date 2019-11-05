# frozen_string_literal: true

class AddEmailIndexToCustomers < ActiveRecord::Migration[5.2]
  def up
    add_index :customers, :email, unique: true
  end

  def down
    remove_index :customers, :email
  end
end
