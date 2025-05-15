module Subscriptions
  class Update < ActiveInteraction::Base
    object :user
    string :price

    validates :price, presence: true
    validate :validate_stripe_state!

    def execute
      data = user.stripe_subscriptions.effective
      subscription_uid = data.subscription_uid

      subscription = Stripe::Subscription.retrieve(subscription_uid)
      subscription_item_uid = subscription.items.data[0].id

      Stripe::SubscriptionItem.update(
        subscription_item_uid, {
          price:,
          payment_behavior: "default_incomplete",
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
