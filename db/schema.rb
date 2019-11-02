# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_11_01_161000) do

  create_table "customers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.date "dob"
    t.bigint "import_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["import_id"], name: "index_customers_on_import_id"
  end

  create_table "imports", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "status", default: "created", null: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.integer "total_records_count", default: 0, null: false
    t.integer "imported_records_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["status"], name: "index_imports_on_status"
  end

  add_foreign_key "customers", "imports"
end
