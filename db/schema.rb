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

ActiveRecord::Schema[8.0].define(version: 2025_05_15_065011) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "stripe_checkout_sessions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "session_uid"
    t.decimal "amount_subtotal", precision: 30
    t.decimal "amount_total", precision: 30
    t.string "status"
    t.string "customer_uid"
    t.integer "created"
    t.integer "expires_at"
    t.text "url"
    t.string "subscription_uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_stripe_checkout_sessions_on_user_id"
  end

  create_table "stripe_invoices", force: :cascade do |t|
    t.string "invoice_uid"
    t.integer "amount_due"
    t.string "billing_reason"
    t.integer "created"
    t.string "customer_uid"
    t.text "hosted_invoice_url"
    t.string "subscription_uid"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["invoice_uid"], name: "index_stripe_invoices_on_invoice_uid", unique: true
  end

  create_table "stripe_subscriptions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "subscription_uid"
    t.string "customer_uid"
    t.integer "current_period_start"
    t.integer "current_period_end"
    t.integer "cancel_at"
    t.integer "canceled_at"
    t.boolean "cancel_at_period_end", default: false
    t.string "status"
    t.integer "created"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_stripe_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
