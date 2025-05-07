class CreateStripeSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :stripe_subscriptions do |t|
      t.integer :user_id, null: false
      t.string :subscription_uid
      t.string :price_uid
      t.integer :current_period_start
      t.integer :current_period_end
      t.string :status

      t.timestamps
    end
  end
end
