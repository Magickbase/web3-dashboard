class CreateStripeSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :stripe_subscriptions do |t|
      t.integer :user_id, null: false
      t.string :subscription_uid
      t.string :price_uid
      t.string :customer_uid
      t.integer :current_period_start
      t.integer :current_period_end
      t.integer :cancel_at
      t.integer :canceled_at
      t.boolean :cancel_at_period_end, default: false
      t.integer :status

      t.timestamps
    end
  end
end
