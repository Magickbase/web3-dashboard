module Subscriptions
  class Update < ActiveInteraction::Base
    object :user
    string :price

    validates :price, presence: true
    validate :validate_stripe_state!

    def execute
      data = user.stripe_subscriptions.effective
      raise ApiError::StripeDuplicateSubscriptionPriceError if price.eql?(data.price_uid)

      subscription_uid = data.subscription_uid
      subscription = Stripe::Subscription.retrieve(subscription_uid)
      subscription_item_uid = subscription.items.data[0].id

      # allow_incomplete: 允许未完成支付状态（incomplete），发票创建后无需立即付款。Stripe 会尝试扣款，失败则订阅进入 incomplete
      # always_invoice: 始终创建一张新的账单（invoice）来结算这次变更。区别是一定会有 invoice（即使金额是 0）
      Stripe::SubscriptionItem.update(
        subscription_item_uid, {
          price:,
          payment_behavior: "allow_incomplete",
          proration_behavior: "always_invoice",
        }
      )
    rescue Stripe::StripeError => e
      raise ApiError::StripeRequestError.new(e.message)
    end

    private

    def validate_stripe_state!
      raise ApiError::StripeActiveSubscriptionNotFoundError unless user.stripe_subscriptions.active.exists?
    end
  end
end
