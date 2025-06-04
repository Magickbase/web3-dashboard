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
      # 已存在则直接返回（幂等保障）
      return if ApiCall.exists?(request_uid:)

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
