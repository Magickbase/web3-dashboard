class CreateApiCredits < ActiveRecord::Migration[8.0]
  def change
    create_table :api_credits do |t|
      t.string :route
      t.integer :credit_cost, default: 0
      t.text :description

      t.timestamps
    end

    add_index :api_credits, :route, unique: true
  end
end
