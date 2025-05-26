class ApiCall < ApplicationRecord
  enum :status, { pending: "pending", success: "success", failed: "failed" }
end

# == Schema Information
#
# Table name: api_calls
#
#  id               :bigint           not null, primary key
#  api_key          :string
#  chain            :string
#  created          :integer
#  credits_used     :integer
#  error_code       :string
#  http_status      :integer
#  path             :string
#  response_time_ms :integer
#  status           :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  request_id       :uuid             not null
#  user_id          :integer
#
# Indexes
#
#  index_api_calls_on_request_id  (request_id) UNIQUE
#
