class CreateStripeCheckoutSessions < ActiveRecord::Migration[8.0]
  def change
    create_table :stripe_checkout_sessions do |t|
      t.integer :user_id, null: false
      t.string :session_uid
      t.decimal :amount_subtotal, precision: 30
      t.decimal :amount_total, precision: 30
      t.integer :status, default: 0
      t.string :customer_uid
      t.integer :created
      t.integer :expires_at
      t.text :url

      t.timestamps
    end

    add_index :stripe_checkout_sessions, :user_id
  end
end
