class CreateStripePrices < ActiveRecord::Migration[8.0]
  def change
    create_table :stripe_prices do |t|
      t.string :nickname
      t.string :price_uid
      t.string :product_uid
      t.boolean :active
      t.integer :created
      t.string :currency
      t.jsonb :metadata, default: {}
      t.integer :unit_amount
      t.string :unit_amount_decimal
      t.string :billing_type
      t.boolean :livemode, default: false
      t.jsonb :recurring, default: {}

      t.timestamps
    end

    add_index :stripe_prices, :price_uid, unique: true
  end
end
