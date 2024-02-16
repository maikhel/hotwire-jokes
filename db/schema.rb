# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_02_10_100606) do
  create_table "jokes", force: :cascade do |t|
    t.string "body"
    t.integer "jokes_request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jokes_request_id"], name: "index_jokes_on_jokes_request_id"
  end

  create_table "jokes_requests", force: :cascade do |t|
    t.integer "amount", null: false
    t.integer "delay", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "jokes", "jokes_requests"
end
