class ApiCall < ApplicationRecord
  belongs_to :user

  scope :unsynced, -> { where(synced: false) }

  # Event format
  # https://openmeter.io/docs/metering/events/usage-events#event-format
  def to_event
    unique_id = request_uid.presence || id
    data = slice(:api_key, :chain, :error_code, :http_status, :route, :source, :request_uid, :credits_used).compact

    {
      specversion: "1.0",
      type: "api_calls",
      id: unique_id,
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
#  chain            :string
#  created          :string
#  credits_used     :integer
#  error_code       :string
#  http_status      :integer
#  request_uid      :string
#  response_time_ms :integer
#  route            :string
#  source           :string
#  synced           :boolean          default(FALSE)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :integer
#
