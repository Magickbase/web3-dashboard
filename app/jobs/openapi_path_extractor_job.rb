require "open-uri"
require "json"

class OpenapiPathExtractorJob
  include Sidekiq::Job

  def perform
    source_url = ENV.fetch("PLATFORM_OPENAPI_URL", nil)
    json = URI.open(source_url).then { |f| JSON.parse(f.read) }
    paths = json["paths"]&.keys
    return if paths.blank?

    attributes = paths.map { |path| { path: } }
    ApiCredit.upsert_all(attributes, unique_by: :path)
  end
end
