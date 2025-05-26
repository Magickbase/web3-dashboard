require "open-uri"
require "json"

class OpenapiPathExtractor
  class FetchError < StandardError; end

  def initialize(source_url: ENV.fetch("PLATFORM_OPENAPI_URL", nil))
    raise ArgumentError, "OpenAPI URL is not set" if source_url.blank?

    @source_url = source_url
  end

  def sync!
    paths = fetch_paths
    return if paths.blank?

    attributes = paths.map { |path| { path: } }
    ApiCredit.upsert_all(attributes, unique_by: :path)
  end

  private

  def fetch_paths
    json = fetch_openapi_json
    json["paths"]&.keys
  rescue JSON::ParserError => e
    raise FetchError, "Failed to parse JSON: #{e.message}"
  end

  def fetch_openapi_json
    URI.open(@source_url).then { |f| JSON.parse(f.read) }
  rescue OpenURI::HTTPError => e
    raise FetchError, "Failed to fetch OpenAPI: #{e.message}"
  rescue SocketError, Errno::ECONNREFUSED => e
    raise FetchError, "Connection failed: #{e.message}"
  end
end
