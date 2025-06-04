class CreateStripeCustomers < ActiveRecord::Migration[8.0]
  def change
    create_table :stripe_customers do |t|
      t.integer :user_id, null: false
      t.string :customer_uid
      t.string :email
      t.integer :created

      t.timestamps
    end
  end
end
