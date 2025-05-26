class CreateApiCalls < ActiveRecord::Migration[8.0]
  def change
    create_table :api_calls do |t|
      t.integer :user_id
      t.uuid :request_id, null: false, index: { unique: true }
      t.string :api_key
      t.string :path
      t.integer :http_status
      t.string :error_code
      t.integer :response_time_ms
      t.string :chain
      t.integer :credits_used
      t.integer :created
      t.string :status

      t.timestamps
    end
  end
end
