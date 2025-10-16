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

ActiveRecord::Schema[7.2].define(version: 2025_10_16_030744) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cigarettes", force: :cascade do |t|
    t.string "name", null: false
    t.integer "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "manufacturer", null: false
    t.integer "position", null: false
    t.index ["manufacturer", "position"], name: "index_cigarettes_on_manufacturer_and_position", unique: true
    t.index ["name"], name: "index_cigarettes_on_name", unique: true
  end

  create_table "custom_cigarette_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "custom_cigarette_id", null: false
    t.integer "packs", null: false
    t.date "bought_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["custom_cigarette_id"], name: "index_custom_cigarette_logs_on_custom_cigarette_id"
    t.index ["user_id"], name: "index_custom_cigarette_logs_on_user_id"
  end

  create_table "custom_cigarettes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", null: false
    t.integer "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_custom_cigarettes_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name", null: false
    t.integer "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "smokes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "cigarette_id", null: false
    t.integer "packs", null: false
    t.date "bought_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cigarette_id"], name: "index_smokes_on_cigarette_id"
    t.index ["user_id"], name: "index_smokes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.bigint "current_cigarette_id"
    t.bigint "current_custom_cigarette_id"
    t.string "provider"
    t.string "uid"
    t.index ["current_cigarette_id"], name: "index_users_on_current_cigarette_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "custom_cigarette_logs", "custom_cigarettes"
  add_foreign_key "custom_cigarette_logs", "users"
  add_foreign_key "custom_cigarettes", "users"
  add_foreign_key "smokes", "cigarettes"
  add_foreign_key "smokes", "users"
  add_foreign_key "users", "cigarettes", column: "current_cigarette_id"
end
