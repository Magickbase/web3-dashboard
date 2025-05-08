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

ActiveRecord::Schema[8.0].define(version: 2025_05_07_084046) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "stripe_checkout_sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "session_uid"
    t.decimal "amount_subtotal", precision: 30
    t.decimal "amount_total", precision: 30
    t.integer "status", default: 0
    t.string "customer_uid"
    t.integer "created"
    t.integer "expires_at"
    t.text "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_stripe_checkout_sessions_on_user_id"
  end

  create_table "stripe_subscriptions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "subscription_uid"
    t.string "price_uid"
    t.integer "current_period_start"
    t.integer "current_period_end"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
