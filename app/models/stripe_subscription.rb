class StripeSubscription < ApplicationRecord
  belongs_to :user
  has_one :stripe_price, foreign_key: :price_uid, primary_key: :price_uid

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

# == Schema Information
#
# Table name: stripe_subscriptions
#
#  id                   :bigint           not null, primary key
#  cancel_at            :integer
#  cancel_at_period_end :boolean          default(FALSE)
#  canceled_at          :integer
#  created              :integer
#  current_period_end   :integer
#  current_period_start :integer
#  customer_uid         :string
#  price_uid            :string
#  status               :string
#  subscription_uid     :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :integer          not null
#
# Indexes
#
#  index_stripe_subscriptions_on_user_id  (user_id)
#
