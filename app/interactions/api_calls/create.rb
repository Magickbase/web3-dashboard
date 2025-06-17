module ApiCalls
  class Create < ActiveInteraction::Base
    object :user
    string :api_key
    string :route
    string :created
    integer :response_time_ms
    string :source, default: "web3-platform"
    hash :input_data, strip: false, default: {}

    def execute
      # 由于传入参数没有 request_id 之类参数无法做幂等
      credits_used = ApiCreditCache.read(route) || 0
      ApplicationRecord.transaction do
        deduct_credits!(credits_used)

        ApiCall.create!(inputs.merge(credits_used: credits_used, user_id: user.id))
      end
    end

    private

    def deduct_credits!(amount)
      if user.remaining_credits >= amount
        user.update!(remaining_credits: user.remaining_credits - amount)
      else
        raise ApiError::InsufficientCreditsError
      end
    end
  end
end
