module ApiCalls
  class Create < ActiveInteraction::Base
    object :user
    string :api_key
    string :chain
    string :created
    string :error_code
    integer :http_status
    string :path
    integer :response_time_ms
    string :request_id
    string :source, default: "web3-platform"

    def execute
      ApiCall.create!(inputs)
    end
  end
end
