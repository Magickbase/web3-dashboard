class CreateStripeProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :stripe_products do |t|
      t.string :name
      t.text :description
      t.string :product_uid
      t.boolean :active, default: true
      t.string :default_price_uid
      t.boolean :livemode, default: false
      t.integer :created
      t.integer :updated
      t.jsonb :metadata, default: {}

      t.timestamps
    end

    add_index :stripe_products, :product_uid, unique: true
  end
end
