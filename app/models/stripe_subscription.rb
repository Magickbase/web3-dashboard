class StripeSubscription < ApplicationRecord
  belongs_to :user

  enum :status, {
    incomplete: "incomplete",
    incomplete_expired: "incomplete_expired",
    trialing: "trialing",
    active: "active",
    past_due: "past_due",
    canceled: "canceled",
    unpaid: "unpaid",
    paused: "paused",
  }

  scope :effective, -> { where(status: "active").first }

  def cancelable?
    return false if canceled_at.present? # 已完全取消
    return false if cancel_at_period_end # 已设为到期取消
    return false unless status.in?(%w[active trialing])

    true
  end

  def usable?
    return false unless status.in?(%w[trialing active past_due])
    return false if canceled_at.present?
    return false if current_period_end.present? && Time.at(current_period_end) < Time.current.utc

    true
  end
end
