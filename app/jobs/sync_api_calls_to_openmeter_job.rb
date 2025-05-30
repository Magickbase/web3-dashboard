class SyncApiCallsToOpenmeterJob
  include Sidekiq::Job

  sidekiq_options queue: "openmeter", retry: 0
  sidekiq_options lock: :until_executed

  def perform
    calls = ApiCall.unsynced.limit(10_000)
    calls.find_in_batches(order: :asc) { |batch| upload_to_openmeter!(batch) }
  end

  def upload_to_openmeter!(calls)
    payload = calls.map(&:to_event)

    path = "#{ENV.fetch('OPENMETER_HOST', nil)}/api/v1/events"
    response = Faraday.post(path) do |req|
      req.headers["Content-Type"] = "application/cloudevents-batch+json"
      req.body = payload.to_json
    end

    if response.success?
      api_call_ids = calls.map(&:id)
      ApiCall.where(id: api_call_ids).update_all(synced: true, updated_at: Time.current)
    else
      raise "Upload failed: #{response.status} - #{response.body}"
    end
  rescue StandardError => e
    Rails.logger.error("Event upload error: #{e.message}")
    raise e
  end
end
