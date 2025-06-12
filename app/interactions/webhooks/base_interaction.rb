module Webhooks
  class BaseInteraction < ActiveInteraction::Base
    object :event, class: Stripe::Event

    def execute
      handle
    rescue StandardError => e
      Rails.logger.error("[StripeWebhook] #{self.class.name} error: #{e.class} - #{e.message}")
      errors.add(:base, e.message)
    end

    # 子类必须实现
    def handle
      raise NotImplementedError, "Subclasses must implement #handle"
    end
  end
end
