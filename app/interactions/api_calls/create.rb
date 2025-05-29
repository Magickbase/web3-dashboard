module ApiCalls
  class Create < ActiveInteraction::Base
    object :user
    string :api_key
    string :chain
    string :created
    string :error_code, default: nil
    integer :http_status
    integer :response_time_ms
    string :route
    string :source, default: "web3-platform"
    string :request_uid

    def execute
      credits_used = ApiCreditCache.read(route)
      ApiCall.create!(inputs.merge(credits_used:))
    end
  end
end
