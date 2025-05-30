module ApiUsage
  class DailyMetrics < ActiveInteraction::Base
    object :user
    def execute
      from, to = generate_time_range
      path = "#{ENV.fetch('OPENMETER_HOST', nil)}/api/v1/meters/api_requests_total/query"

      response = Faraday.get(path) do |req|
        req.params["subject"] = "user_#{user.id}"
        req.params["windowSize"] = "DAY"
        req.params["from"] = from
        req.params["to"] = to
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

    # 时间格式 2025-06-01T00:00:00.000Z
    def generate_time_range
      now = Time.now.utc
      end_time = now.end_of_day.change(usec: 999_000).iso8601(3)
      start_time = (now - 1.month).beginning_of_day.change(usec: 0).iso8601(3)

      [start_time, end_time]
    end

    def wrap_result(data)
      grouped = {}

      data.each do |entry|
        date = Date.parse(entry["windowStart"]).to_s
        route = entry.dig("groupBy", "route")
        value = entry["value"]

        grouped[date] ||= {}
        grouped[date][route] ||= 0
        grouped[date][route] += value
      end

      grouped.map do |date, routes|
        { date: date, data: routes }
      end.sort_by { |entry| entry[:date] }
    end
  end
end
