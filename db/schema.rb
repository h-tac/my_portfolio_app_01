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

ActiveRecord::Schema[7.0].define(version: 2023_09_24_090844) do
  create_table "comments", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "spot_id", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_id"], name: "index_comments_on_spot_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "deletion_requests", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "spot_id", null: false
    t.string "name", null: false
    t.string "email", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_id"], name: "index_deletion_requests_on_spot_id"
  end

  create_table "favorites", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "spot_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_id"], name: "index_favorites_on_spot_id"
    t.index ["user_id", "spot_id"], name: "index_favorites_on_user_id_and_spot_id", unique: true
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "pumps", charset: "utf8mb4", force: :cascade do |t|
    t.string "usage", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["usage"], name: "index_pumps_on_usage", unique: true
  end

  create_table "spots", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name", null: false
    t.string "address_prefecture", null: false
    t.string "address_city", null: false
    t.string "address_detail", null: false
    t.integer "fee", default: 0, null: false
    t.time "opening_time"
    t.time "closing_time"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "latitude", precision: 18, scale: 14, null: false
    t.decimal "longitude", precision: 18, scale: 14, null: false
    t.index ["address_detail"], name: "index_spots_on_address_detail", unique: true
    t.index ["latitude", "longitude"], name: "index_spots_on_latitude_and_longitude", unique: true
    t.index ["user_id"], name: "index_spots_on_user_id"
  end

  create_table "spots_pumps", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "spot_id", null: false
    t.bigint "pump_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pump_id"], name: "index_spots_pumps_on_pump_id"
    t.index ["spot_id", "pump_id"], name: "index_spots_pumps_on_spot_id_and_pump_id", unique: true
    t.index ["spot_id"], name: "index_spots_pumps_on_spot_id"
  end

  create_table "spots_valves", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "spot_id", null: false
    t.bigint "valve_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spot_id", "valve_id"], name: "index_spots_valves_on_spot_id_and_valve_id", unique: true
    t.index ["spot_id"], name: "index_spots_valves_on_spot_id"
    t.index ["valve_id"], name: "index_spots_valves_on_valve_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  create_table "valves", charset: "utf8mb4", force: :cascade do |t|
    t.string "kind", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["kind"], name: "index_valves_on_kind", unique: true
  end

  add_foreign_key "comments", "spots"
  add_foreign_key "comments", "users", on_delete: :nullify
  add_foreign_key "deletion_requests", "spots"
  add_foreign_key "favorites", "spots"
  add_foreign_key "favorites", "users"
  add_foreign_key "spots", "users", on_delete: :nullify
  add_foreign_key "spots_pumps", "pumps"
  add_foreign_key "spots_pumps", "spots"
  add_foreign_key "spots_valves", "spots"
  add_foreign_key "spots_valves", "valves"
end
