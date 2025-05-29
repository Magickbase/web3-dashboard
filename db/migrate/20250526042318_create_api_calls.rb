class CreateApiCalls < ActiveRecord::Migration[8.0]
  def change
    create_table :api_calls do |t|
      t.integer :user_id
      t.string :request_id
      t.string :api_key
      t.string :route
      t.integer :http_status
      t.string :error_code
      t.integer :response_time_ms
      t.string :chain
      t.integer :credits_used
      t.string :created
      t.boolean :synced, default: false
      t.string :source

      t.timestamps
    end
  end
end
