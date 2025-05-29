class OpenapiPathExtractorJob
  include Sidekiq::Job

  def perform
    source_url = ENV.fetch("PLATFORM_OPENAPI_URL", nil)
    response = Faraday.get(source_url)
    return unless response.success?

    json = JSON.parse(response.body)
    paths = json["paths"]&.keys
    return if paths.blank?

    ApiCredit.upsert_all(paths.map { |route| { route: } }, unique_by: :route)
    sync_credit_to_redis
  end

  def sync_credit_to_redis
    ApiCredit.find_each do |credit|
      ApiCreditCache.write(credit.route, credit.credit_cost)
    end
  end
end
