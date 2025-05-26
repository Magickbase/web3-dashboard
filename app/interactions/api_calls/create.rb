module ApiCalls
  class Create < ActiveInteraction::Base
    object :user
    string :api_key
    string :chain
    integer :created
    string :error_code
    integer :http_status
    string :path
    integer :response_time_ms
    string :request_id

    def execute
      ApiCall.create!(inputs)
    end
  end
end
