class StripeSubscriptionSerializer
  include JSONAPI::Serializer

  set_id :subscription_uid
  attributes :customer_uid, :current_period_start, :current_period_end, :cancel_at, :canceled_at, :cancel_at_period_end, :status, :stripe_price, :stripe_product
end
