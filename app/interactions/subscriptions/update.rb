module Subscriptions
  class Update < ActiveInteraction::Base
    object :user
    string :price

    validates :price, presence: true
    validate :validate_stripe_state!

    def execute
      subscription = user.stripe_subscriptions.effective
      retrieve_data = Stripe::Subscription.retrieve(subscription.subscription_uid)
      current_item_id = retrieve_data.items.data[0].id
      Stripe::SubscriptionItem.update(
        current_item_id, {
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
