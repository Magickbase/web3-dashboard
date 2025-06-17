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

ActiveRecord::Schema[8.0].define(version: 2025_06_17_074734) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "api_calls", force: :cascade do |t|
    t.integer "user_id"
    t.string "request_uid"
    t.string "api_key"
    t.string "route"
    t.integer "http_status"
    t.string "error_code"
    t.integer "response_time_ms"
    t.integer "credits_used"
    t.string "created"
    t.boolean "synced", default: false
    t.string "source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "input_data", default: {}
    t.index ["request_uid"], name: "index_api_calls_on_request_uid", unique: true
  end

  create_table "api_credits", force: :cascade do |t|
    t.string "route"
    t.integer "credit_cost", default: 0
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["route"], name: "index_api_credits_on_route", unique: true
  end

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
    t.string "price_uid"
    t.index ["user_id"], name: "index_stripe_checkout_sessions_on_user_id"
  end

  create_table "stripe_customers", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "customer_uid"
    t.string "email"
    t.integer "created"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "stripe_prices", force: :cascade do |t|
    t.string "nickname"
    t.string "price_uid"
    t.string "product_uid"
    t.boolean "active"
    t.integer "created"
    t.string "currency"
    t.jsonb "metadata", default: {}
    t.integer "unit_amount"
    t.string "unit_amount_decimal"
    t.string "billing_type"
    t.boolean "livemode", default: false
    t.jsonb "recurring", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["price_uid"], name: "index_stripe_prices_on_price_uid", unique: true
  end

  create_table "stripe_products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "product_uid"
    t.boolean "active", default: true
    t.string "default_price_uid"
    t.boolean "livemode", default: false
    t.integer "created"
    t.integer "updated"
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_uid"], name: "index_stripe_products_on_product_uid", unique: true
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
    t.string "price_uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_stripe_subscriptions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subject"
    t.bigint "total_credits", default: 0
    t.bigint "remaining_credits", default: 0
  end
end
