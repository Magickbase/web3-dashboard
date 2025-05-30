module ApiUsage
  class Show < ActiveInteraction::Base
    object :user
    string :indicator

    validates :indicator, inclusion: { in: %w[daily_metrics summary] }
    def execute
      if indicator == "daily_metrics"
        compose(ApiUsage::DailyMetrics, user:)
      else
        compose(ApiUsage::Summary, user:)
      end
    end
  end
end
