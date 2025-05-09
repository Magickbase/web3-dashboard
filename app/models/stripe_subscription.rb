class StripeSubscription < ApplicationRecord
  belongs_to :user

  enum :status, { active: 0, canceled: 1 }

  scope :effective, -> { where(status: :active).first }

  def cancelable?
    return false if canceled_at.present? # 已完全取消
    return false if cancel_at_period_end # 已设为到期取消
    return false unless active? # 非 active 状态不允许

    true
  end
end
