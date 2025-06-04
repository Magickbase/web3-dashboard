class ApiCallSerializer
  include JSONAPI::Serializer

  attributes :id, :api_key, :chain, :created, :error_code, :http_status,
             :request_uid, :response_time_ms, :route
end
