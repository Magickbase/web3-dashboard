class ApiCallSerializer
  include JSONAPI::Serializer

  attributes :id, :api_key, :created, :response_time_ms, :route, :input_data
end
