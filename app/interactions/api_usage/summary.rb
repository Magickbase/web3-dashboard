module ApiUsage
  class Summary < ActiveInteraction::Base
    object :user

    def execute
      path = "#{ENV.fetch('OPENMETER_HOST', nil)}/api/v1/meters/api_requests_total/query"

      response = Faraday.get(path) do |req|
        req.params["subject"] = "user_#{user.id}"
        req.params["groupBy"] = "route"
      end

      if response.success?
        result = JSON.parse(response.body)
        wrap_result(result["data"])
      else
        error = JSON.parse(response.body)
        raise ApiError::MetersQueryFailureError.new(error["status"], error["detail"])
      end
    end

    private

    def wrap_result(data)
      data.map do |entry|
        route = entry["groupBy"]["route"]
        multiplier = ApiCreditCache.read(route) || 0

        {
          route:,
          value: entry["value"],
          multiplier:,
        }
      end.sort_by { |entry| -entry[:value] }
    end
  end
end
