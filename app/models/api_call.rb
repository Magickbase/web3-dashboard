class ApiCall < ApplicationRecord
  belongs_to :user

  scope :unsynced, -> { where(synced: false) }

  # Event format
  # https://openmeter.io/docs/metering/events/usage-events#event-format
  def to_event
    data = slice(:api_key, :route, :source, :credits_used, :input_data, :response_time_ms).compact

    {
      specversion: "1.0",
      type: "request",
      id: id.to_s,
      time: created,
      source:,
      subject: "user_#{user_id}",
      data:,
    }
  end
end

# == Schema Information
#
# Table name: api_calls
#
#  id               :bigint           not null, primary key
#  api_key          :string
#  created          :string
#  credits_used     :integer
#  error_code       :string
#  http_status      :integer
#  input_data       :jsonb
#  request_uid      :string
#  response_time_ms :integer
#  route            :string
#  source           :string
#  synced           :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#
# Indexes
#
#  index_api_calls_on_request_uid  (request_uid) UNIQUE
#
